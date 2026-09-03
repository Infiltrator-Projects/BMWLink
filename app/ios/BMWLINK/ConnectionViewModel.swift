// SPDX-License-Identifier: GPL-3.0-or-later
import Combine
import Foundation

@MainActor
final class ConnectionViewModel: NSObject, ObservableObject, @preconcurrency BmwLinkDiagnosticsControllerDelegate {
    @Published private(set) var statusText = "Idle"
    @Published private(set) var peripheralName = "No adapter"
    @Published private(set) var adapterIdentifier = "Unknown"
    @Published private(set) var vehicleVINText = "Waiting for standard VIN"
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
    @Published private(set) var isActive = false
    @Published private(set) var isReady = false
    @Published private(set) var recordedSampleCount = 0
    @Published private(set) var versionText = "Unknown"
    @Published private(set) var csvExportURL: URL?
    @Published private(set) var languageTags = [String]()
    @Published private(set) var languageNames = [String]()
    @Published private(set) var selectedLanguageID = "en-AU"
    @Published private(set) var measurementKeys = [String]()
    @Published private(set) var measurementNames = [String]()
    @Published private(set) var selectedMeasurementID = "metric"

    private let controller = BmwLinkDiagnosticsController()

    override init() {
        super.init()
        controller.delegate = self
        if let value = bmwlink_version() { versionText = String(cString: value) }
        refresh()
    }

    func connect() { if !isActive { controller.start() } }
    func disconnect() { controller.disconnect() }

    var interfaceLocaleIdentifier: String { selectedLanguageID }

    func localizedText(_ key: String) -> String { controller.localizedText(forKey: key) }
    func selectLanguage(_ id: String) { controller.setSelectedLanguageTag(id); refresh() }
    func selectMeasurementSystem(_ id: String) { controller.setSelectedMeasurementSystemKey(id); refresh() }

    func prepareCSVExport() {
        guard let snapshot = controller.csvDataSnapshot() else { return }
        let data = snapshot as Data
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("BMWLINK-diagnostic-evidence-\(UUID().uuidString).csv")
        do {
            try data.write(to: url, options: .atomic)
            csvExportURL = url
        } catch {
            csvExportURL = nil
        }
    }

    func diagnosticsControllerDidUpdate(_ controller: BmwLinkDiagnosticsController) {
        refresh()
    }

    private func refresh() {
        statusText = controller.statusText
        peripheralName = controller.peripheralName ?? "No adapter"
        adapterIdentifier = controller.adapterIdentifier ?? "Unknown"
        vehicleVINText = controller.vehicleVINText
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
        isActive = controller.isActive
        isReady = controller.isReady
        recordedSampleCount = Int(clamping: controller.recordedSampleCount)
    }
}
