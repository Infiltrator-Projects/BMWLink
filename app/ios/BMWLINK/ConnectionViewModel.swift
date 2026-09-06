// SPDX-License-Identifier: GPL-3.0-or-later
import Combine
import Foundation
import UIKit

struct BmwSavedVehicleSummary: Identifiable {
    let id: String
    let vin: String
    let displayName: String
    let adapterIdentifier: String?
}

@MainActor
final class ConnectionViewModel: NSObject, ObservableObject, @preconcurrency BmwLinkDiagnosticsControllerDelegate {
    @Published private(set) var statusText = "Idle"
    @Published private(set) var peripheralName = "No adapter"
    @Published private(set) var adapterIdentifier = "Unknown"
    @Published private(set) var obdProtocolText = "OBD-II protocol not identified"
    @Published private(set) var vehicleVINText = "No vehicle loaded"
    @Published private(set) var faultScanStatusText = "Not scanned"
    @Published private(set) var storedDTCs = [String]()
    @Published private(set) var pendingDTCs = [String]()
    @Published private(set) var permanentDTCs = [String]()
    @Published private(set) var readinessStatusText = "Not read"
    @Published private(set) var readinessMonitorStatus = [String]()
    @Published private(set) var freezeFrameContext = [String]()
    @Published private(set) var diagnosticCapabilityText = "Unknown / probing"
    @Published private(set) var diagnosticCapabilityDetailText = ""
    @Published private(set) var standardResponderSummary = "0 physical responders"
    @Published private(set) var supportedPIDSummary = "0 advertised PIDs"
    @Published private(set) var standardLiveRows = [String]()
    @Published private(set) var diagnosticParameters = [LinkDiagnosticParameter]()
    @Published private(set) var dashboardParameters = [LinkDiagnosticParameter]()
    @Published private(set) var savedVehicleProfiles = [BmwSavedVehicleSummary]()
    @Published private(set) var selectedVehicleVIN: String?
    @Published private(set) var isActive = false
    @Published private(set) var isReady = false
    @Published private(set) var isSimulationActive = false
    @Published private(set) var recordedSampleCount = 0
    @Published private(set) var versionText = "Unknown"
    @Published private(set) var linkVersionText = "Unknown"
    @Published private(set) var csvExportURL: URL?
    @Published private(set) var isPreparingCSV = false
    @Published private(set) var languageTags = [String]()
    @Published private(set) var languageNames = [String]()
    @Published private(set) var selectedLanguageID = "en-AU"
    @Published private(set) var measurementKeys = [String]()
    @Published private(set) var measurementNames = [String]()
    @Published private(set) var selectedMeasurementID = "metric"

    private let controller = BmwLinkDiagnosticsController()
    private let vehicleProfileStore = LinkVehicleProfileStore(
        productNamespace: "bmwlink",
        legacyProfileKey: nil,
        legacySelectedVINKey: nil,
        legacyAdapterMappingKey: nil)
    private let dashboardSelectionStore = LinkPIDSelectionStore(
        productNamespace: "bmwlink",
        legacyGlobalKey: nil,
        legacyVehicleKey: nil)
    private let pollingSelectionStore = LinkPIDSelectionStore(
        productNamespace: "bmwlink-polling",
        legacyGlobalKey: nil,
        legacyVehicleKey: nil)
    private var lastPersistedLiveVIN: String?
    private var lastCapabilityMergeVIN: String?

    var interfaceLocaleIdentifier: String { selectedLanguageID }
    var selectedVehicleDisplayName: String {
        guard let selectedVehicleVIN else { return "No vehicle loaded" }
        return savedVehicleProfiles.first(where: { $0.vin == selectedVehicleVIN })?.displayName
            ?? "BMW vehicle"
    }

    override init() {
        super.init()
        selectedVehicleVIN = vehicleProfileStore.selectedVehicleVIN
        seedDefaultPollingSelection()
        applyStoredPollingPolicy()
        controller.delegate = self
        if let value = bmwlink_version() { versionText = String(cString: value) }
        refresh()
    }

    func connect() {
        clearPreparedExport()
        guard !isActive else { return }
        guard let presenter = presentingViewController() else {
            beginConnection(.automatic)
            return
        }
        let currentVehicleText: String
        if let selectedVehicleVIN {
            currentVehicleText = "\(selectedVehicleDisplayName) · \(selectedVehicleVIN)"
        } else {
            currentVehicleText = "No saved vehicle loaded"
        }
        let picker = LinkConnectionPickerViewController(
            vehicleText: currentVehicleText,
            knownAdapterIdentifier: associatedAdapterIdentifier(for: selectedVehicleVIN)
        ) { [weak self] source in
            Task { @MainActor [weak self] in self?.beginConnection(source) }
        }
        let navigation = UINavigationController(rootViewController: picker)
        navigation.modalPresentationStyle = .pageSheet
        presenter.present(navigation, animated: true)
    }

    private func beginConnection(_ source: LinkConnectionSource) {
        guard !isActive else { return }
        lastPersistedLiveVIN = nil
        lastCapabilityMergeVIN = nil
        switch source {
        case .automatic:
            isSimulationActive = false
            controller.start()
        case .simulated:
            isSimulationActive = true
            controller.startSimulated()
        case .peripheral(let identifier):
            isSimulationActive = false
            controller.start(withPeripheralIdentifier: identifier)
        }
    }

    func disconnect() {
        controller.disconnect()
        isSimulationActive = false
    }

    func selectSavedVehicle(vin: String) {
        guard !isActive else { return }
        guard vehicleProfileStore.selectOfflineVehicle(withVIN: vin) else { return }
        selectedVehicleVIN = vin
        refresh()
    }

    func localizedText(_ key: String) -> String { controller.localizedText(forKey: key) }
    func selectLanguage(_ id: String) { controller.setSelectedLanguageTag(id); refresh() }
    func selectMeasurementSystem(_ id: String) { controller.setSelectedMeasurementSystemKey(id); refresh() }

    func toggleFavourite(_ parameter: LinkDiagnosticParameter) {
        guard let pid = UInt8(exactly: parameter.parameterIdentifier) else { return }
        controller.setFavourite(!controller.favourite(forPID: pid), forPID: pid)
        refresh()
    }

    func togglePolling(_ parameter: LinkDiagnosticParameter) {
        guard let pid = UInt8(exactly: parameter.parameterIdentifier) else { return }
        let enabled = !controller.pollingEnabled(forPID: pid)
        var enabledKeys = Set(pollingSelectionStore.globalStableKeys)
        if enabled {
            enabledKeys.insert(parameter.id)
        } else {
            enabledKeys.remove(parameter.id)
        }
        pollingSelectionStore.setGlobalStableKeys(Array(enabledKeys).sorted())
        controller.setPollingEnabled(enabled, forPID: pid)
        refresh()
    }

    func prepareCSVExport() {
        guard !isPreparingCSV, let snapshot = controller.csvDataSnapshot() else { return }
        clearPreparedExport()
        isPreparingCSV = true
        let data = snapshot as Data
        Task { [weak self] in
            do {
                let url = try await LinkEvidenceExport.prepareTemporaryCSV(
                    data, productName: "BMWLINK")
                guard let self else {
                    LinkEvidenceExport.removeTemporaryFile(url)
                    return
                }
                self.csvExportURL = url
            } catch {
                self?.csvExportURL = nil
            }
            self?.isPreparingCSV = false
        }
    }

    func diagnosticsControllerDidUpdate(_ controller: BmwLinkDiagnosticsController) {
        refresh()
    }

    private func associatedAdapterIdentifier(for vin: String?) -> String? {
        guard let vin else { return nil }
        return vehicleProfileStore.associatedAdapterIdentifier(forVIN: vin)
    }

    private func refreshSavedVehicleProfiles() {
        savedVehicleProfiles = vehicleProfileStore.savedProfiles.compactMap { profile in
            guard let vin = profile["vin"] as? String, vin.count == 17 else { return nil }
            return BmwSavedVehicleSummary(
                id: vin,
                vin: vin,
                displayName: (profile["displayName"] as? String) ?? "BMW vehicle",
                adapterIdentifier: vehicleProfileStore.associatedAdapterIdentifier(forVIN: vin))
        }
        selectedVehicleVIN = vehicleProfileStore.selectedVehicleVIN
    }

    private func saveVehicleProfile(vin: String) {
        var profile = vehicleProfileStore.profile(forVIN: vin) ?? [:]
        if profile["displayName"] == nil { profile["displayName"] = "BMW vehicle · \(vin)" }
        profile["manufacturer"] = "BMW"
        profile["obdProtocolText"] = controller.obdProtocolText
        profile["diagnosticCapabilityText"] = controller.diagnosticCapabilityText
        vehicleProfileStore.saveProfile(profile, forVIN: vin)
    }

    private func mergeStandardCapabilitiesIfReady(vin: String) {
        guard controller.isReady, lastCapabilityMergeVIN != vin else { return }
        if let flow = controller.diagnosticFlow() {
            _ = vehicleProfileStore.mergeStandardCapabilities(
                fromDiagnosticFlow: flow, forVIN: vin)
            lastCapabilityMergeVIN = vin
        }
    }

    private func loadDiagnosticParameters() -> [LinkDiagnosticParameter] {
        let count = Int(link_obd2_pid_definition_count())
        var result = [LinkDiagnosticParameter]()
        result.reserveCapacity(count)
        for index in 0..<count {
            guard let definition = link_obd2_pid_definition_at(index) else { continue }
            let metadata = definition.pointee
            guard metadata.mode == 0x01, let name = metadata.name else { continue }
            let pid = metadata.pid
            let supported = controller.supportsPID(pid)
            let pollingEnabled = controller.pollingEnabled(forPID: pid)
            let history = controller.displayRecentValues(forPID: pid, limit: 60).map(\.doubleValue)
            let value = history.last
            let unit = controller.displayUnit(forPID: pid)
            let range = controller.displayRange(forPID: pid)
            let minimum = range.count >= 2 ? range[0].doubleValue : nil
            let maximum = range.count >= 2 ? range[1].doubleValue : nil
            let suffix = unit.isEmpty ? "" : " \(unit)"
            let formatted = value.map { String(format: "%.1f%@", $0, suffix) } ?? "N/A"
            let stableKey = String(format: "obd2-01-%02X", pid)
            result.append(LinkDiagnosticParameter(
                id: stableKey,
                protocolName: "OBD2",
                moduleIdentifier: 0,
                parameterIdentifier: UInt32(pid),
                shortName: String(format: "PID %02X", pid),
                title: String(cString: name),
                suffix: unit,
                formattedValue: formatted,
                value: value,
                structuredValue: nil,
                rawHex: nil,
                vehicleSupported: supported,
                favourite: controller.favourite(forPID: pid),
                pollingEnabled: pollingEnabled,
                history: history,
                sourceLabel: "SAE OBD-II",
                qualityNote: supported && !pollingEnabled ? "Polling disabled" : nil,
                dashboardMinimum: minimum,
                dashboardMaximum: maximum))
        }
        return result
    }

    private func refreshDashboardSelection() {
        let supported = diagnosticParameters.filter(\.vehicleSupported)
        if !dashboardSelectionStore.hasGlobalSelection {
            let preferredPIDs: [UInt32] = [0x0C, 0x0D, 0x05, 0x11, 0x04, 0x0F]
            let preferred = preferredPIDs.compactMap { pid in
                supported.first(where: { $0.parameterIdentifier == pid })?.id
            }
            let defaults = preferred.isEmpty ? Array(supported.prefix(6).map(\.id)) : preferred
            if !defaults.isEmpty { dashboardSelectionStore.setGlobalStableKeys(defaults) }
        }
        let selected = Set(dashboardSelectionStore.globalStableKeys)
        let chosen = diagnosticParameters.filter { selected.contains($0.id) && $0.vehicleSupported }
        dashboardParameters = chosen.isEmpty ? Array(supported.prefix(6)) : chosen
    }

    private func allStandardPollingKeys() -> [String] {
        let count = Int(link_obd2_pid_definition_count())
        return (0..<count).compactMap { index in
            guard let definition = link_obd2_pid_definition_at(index) else { return nil }
            let metadata = definition.pointee
            guard metadata.mode == 0x01, (metadata.pid & 0x1F) != 0 else { return nil }
            return String(format: "obd2-01-%02X", metadata.pid)
        }
    }

    private func seedDefaultPollingSelection() {
        guard !pollingSelectionStore.hasGlobalSelection else { return }
        pollingSelectionStore.setGlobalStableKeys(allStandardPollingKeys())
    }

    private func applyStoredPollingPolicy() {
        let enabledKeys = Set(pollingSelectionStore.globalStableKeys)
        let count = Int(link_obd2_pid_definition_count())
        for index in 0..<count {
            guard let definition = link_obd2_pid_definition_at(index) else { continue }
            let metadata = definition.pointee
            guard metadata.mode == 0x01, (metadata.pid & 0x1F) != 0 else { continue }
            let stableKey = String(format: "obd2-01-%02X", metadata.pid)
            controller.setPollingEnabled(
                enabledKeys.contains(stableKey),
                forPID: metadata.pid)
        }
    }

    private func refresh() {
        refreshSavedVehicleProfiles()
        statusText = controller.statusText
        peripheralName = controller.peripheralName ?? "No adapter"
        adapterIdentifier = controller.adapterIdentifier ?? "Unknown"
        obdProtocolText = controller.obdProtocolText
        let active = controller.isActive
        let liveVIN = controller.vehicleVINText
        vehicleVINText = active ? liveVIN : (selectedVehicleVIN ?? "No vehicle loaded")

        if active, liveVIN.count == 17, lastPersistedLiveVIN != liveVIN {
            vehicleProfileStore.recordLiveVIN(liveVIN)
            selectedVehicleVIN = liveVIN
            saveVehicleProfile(vin: liveVIN)
            lastPersistedLiveVIN = liveVIN
            refreshSavedVehicleProfiles()
        }
        if active, liveVIN.count == 17 {
            mergeStandardCapabilitiesIfReady(vin: liveVIN)
        }

        faultScanStatusText = controller.faultScanStatusText
        storedDTCs = controller.storedDTCs
        pendingDTCs = controller.pendingDTCs
        permanentDTCs = controller.permanentDTCs
        readinessStatusText = controller.readinessStatusText
        readinessMonitorStatus = controller.readinessMonitorStatus
        freezeFrameContext = controller.freezeFrameContext
        diagnosticCapabilityText = controller.diagnosticCapabilityText
        diagnosticCapabilityDetailText = controller.diagnosticCapabilityDetailText
        standardResponderSummary = controller.standardResponderSummary
        supportedPIDSummary = controller.supportedPIDSummary
        standardLiveRows = controller.standardLiveValueRows
        languageTags = controller.availableLanguageTags
        languageNames = controller.availableLanguageNames
        selectedLanguageID = controller.selectedLanguageTag
        measurementKeys = controller.availableMeasurementSystemKeys
        measurementNames = controller.availableMeasurementSystemNames
        selectedMeasurementID = controller.selectedMeasurementSystemKey
        linkVersionText = controller.linkVersionText
        isActive = active
        isReady = controller.isReady
        diagnosticParameters = loadDiagnosticParameters()
        refreshDashboardSelection()
        recordedSampleCount = Int(clamping: controller.recordedSampleCount)
    }

    private func presentingViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let root = scene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return nil
        }
        return topViewController(root)
    }

    private func topViewController(_ controller: UIViewController) -> UIViewController {
        if let presented = controller.presentedViewController { return topViewController(presented) }
        if let navigation = controller as? UINavigationController,
           let visible = navigation.visibleViewController { return topViewController(visible) }
        if let tabs = controller as? UITabBarController,
           let selected = tabs.selectedViewController { return topViewController(selected) }
        return controller
    }

    private func clearPreparedExport() {
        LinkEvidenceExport.removeTemporaryFile(csvExportURL)
        csvExportURL = nil
    }
}
