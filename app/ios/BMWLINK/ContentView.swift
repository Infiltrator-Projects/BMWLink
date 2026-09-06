// SPDX-License-Identifier: GPL-3.0-or-later
import SwiftUI

private enum ProductTheme {
    static let backgroundTop = Color(red: 0.02, green: 0.035, blue: 0.055)
    static let backgroundMiddle = Color(red: 0.035, green: 0.065, blue: 0.095)
    static let backgroundBottom = Color(red: 0.055, green: 0.09, blue: 0.13)
    static let panel = Color(red: 0.055, green: 0.09, blue: 0.13)
    static let panelRaised = Color(red: 0.075, green: 0.14, blue: 0.20)
    static let border = Color(red: 0.16, green: 0.32, blue: 0.47)
    static let accent = Color(red: 0.11, green: 0.41, blue: 0.83)
    static let primary = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let secondary = Color(red: 0.59, green: 0.70, blue: 0.80)
    static let success = Color(red: 0.34, green: 0.78, blue: 0.48)
    static let warning = Color(red: 0.95, green: 0.68, blue: 0.25)
    static let fault = Color(red: 0.90, green: 0.22, blue: 0.28)
}

private let productTheme = LinkDiagnosticTheme(
    backgroundTop: ProductTheme.backgroundTop,
    backgroundMiddle: ProductTheme.backgroundMiddle,
    backgroundBottom: ProductTheme.backgroundBottom,
    panel: ProductTheme.panel,
    panelRaised: ProductTheme.panelRaised,
    primaryText: ProductTheme.primary,
    secondaryText: ProductTheme.secondary,
    mutedText: ProductTheme.secondary.opacity(0.72),
    border: ProductTheme.border.opacity(0.72),
    accent: ProductTheme.accent,
    success: ProductTheme.success,
    warning: ProductTheme.warning,
    fault: ProductTheme.fault,
    typography: LinkDiagnosticTypography(
        display: .system(size: 29, weight: .semibold),
        body: .body,
        bodyBold: .body.bold(),
        subheadline: .subheadline,
        subheadlineBold: .subheadline.bold(),
        headline: .headline,
        caption: .caption,
        captionBold: .caption.bold(),
        caption2: .caption2,
        caption2Bold: .caption2.bold(),
        title3: .title3,
        title2: .title2.bold()))

private struct ProductBadge: View {
    var size: CGFloat = 56
    var body: some View {
        Image("BMWLINKEmblem")
            .resizable().scaledToFit()
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.28), radius: 7, x: 0, y: 4)
            .accessibilityHidden(true)
    }
}

private extension View {
    func productDiagnosticScreen(_ title: String) -> some View { linkDiagnosticScreen(title) }
}

struct ContentView: View {
    @StateObject private var model = ConnectionViewModel()
    @State private var showingAbout = false

    var body: some View {
        LinkCommandCentreShell(
            showProgress: model.isActive && !model.isReady,
            header: { header },
            progress: { connectionProgress },
            connection: { connectionCard },
            primary: { primaryGrid },
            tools: { EmptyView() })
            .linkDiagnosticTheme(productTheme)
            .linkDiagnosticLocalization { model.localizedText($0) }
            .environment(\.locale, Locale(identifier: model.interfaceLocaleIdentifier))
            .environment(\.layoutDirection,
                model.interfaceLocaleIdentifier.hasPrefix("ar") ? .rightToLeft : .leftToRight)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                LinkDiagnosticAboutButton(productName: "BMWLINK", copyright: "© 2026 Shannon Smith") {
                    showingAbout = true
                }.linkDiagnosticTheme(productTheme)
            }
            .sheet(isPresented: $showingAbout) {
                LinkDiagnosticAboutView(info: aboutInfo, onClose: { showingAbout = false }) {
                    ProductBadge(size: 82)
                }
                .linkDiagnosticTheme(productTheme)
                .preferredColorScheme(.dark)
                .tint(ProductTheme.accent)
            }
    }

    private var aboutInfo: LinkDiagnosticAboutInfo {
        LinkDiagnosticAboutInfo(
            productName: "BMWLINK",
            subtitle: "BMW · LINK DIAGNOSTICS",
            version: model.versionText,
            summary: "Open-source BMW diagnostics built as a branded product face on the shared LINK engine.",
            authors: ["Shannon Smith"],
            copyright: "Copyright © 2026 Shannon Smith",
            website: URL(string: "https://github.com/Infiltrator-Projects/BMWLink"),
            licenseName: "GPL-3.0-or-later",
            licenseText: "BMWLINK is free software licensed under GNU GPL v3 or later. See LICENSE in the source package for the complete licence text.",
            credits: ["Shannon Smith — Author and project maintainer"])
    }

    private var header: some View {
        LinkBrandHeader {
            HStack(spacing: 14) {
                ProductBadge()
                VStack(alignment: .leading, spacing: 3) {
                    Text("BMWLINK").font(.system(size: 29, weight: .bold)).tracking(1.2).foregroundStyle(ProductTheme.primary)
                    Text("BMW · LINK DIAGNOSTICS").font(.caption2.bold()).tracking(1.2).foregroundStyle(ProductTheme.accent)
                    Text("LINK shared engine · BMW-specific knowledge layered above")
                        .font(.caption).foregroundStyle(ProductTheme.secondary).lineLimit(1)
                }
            }
        } status: { LinkStatusPill(text: model.statusText, active: model.isReady) }
    }

    private var connectionCard: some View {
        LinkPanel {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(model.isActive ? "Diagnostic session" : "Vehicle connection")
                            .font(.headline).foregroundStyle(ProductTheme.primary)
                        Text(model.isActive ? model.statusText : model.selectedVehicleDisplayName)
                            .font(.caption).foregroundStyle(ProductTheme.secondary)
                    }
                    Spacer()
                    Image(systemName: model.isReady ? "checkmark.circle.fill" : model.isActive ? "dot.radiowaves.left.and.right" : "cable.connector")
                        .foregroundStyle(model.isReady ? ProductTheme.success : ProductTheme.accent)
                }
                Button { model.isActive ? model.disconnect() : model.connect() } label: {
                    Label(model.isActive ? "Disconnect" : "Connect to vehicle",
                          systemImage: model.isActive ? "cable.connector.slash" : "cable.connector")
                        .font(.subheadline.weight(.semibold)).foregroundStyle(ProductTheme.primary)
                        .frame(maxWidth: .infinity).padding(.vertical, 11)
                        .background(RoundedRectangle(cornerRadius: 12).fill(ProductTheme.accent))
                }.buttonStyle(.plain)
                if model.isReady {
                    Text("\(model.vehicleVINText) · \(model.diagnosticCapabilityText)")
                        .font(.caption2.monospaced()).foregroundStyle(ProductTheme.secondary)
                }
            }
        }
    }

    private var connectionProgress: some View {
        LinkPanel {
            VStack(alignment: .leading, spacing: 7) {
                Label("Connecting to vehicle", systemImage: "dot.radiowaves.left.and.right")
                    .font(.headline).foregroundStyle(ProductTheme.primary)
                Text(model.statusText).font(.subheadline).foregroundStyle(ProductTheme.secondary)
                if model.peripheralName != "No adapter" {
                    Text(model.peripheralName).font(.caption).foregroundStyle(ProductTheme.secondary)
                }
            }
        }
    }

    private var primaryGrid: some View {
        LinkDiagnosticGrid {
            LinkTaskTile(.vehicle) { ProductVehicleView(model: model) }
            LinkTaskTile(.log) { ProductEvidenceView(model: model) }
            LinkTaskTile(.errors) { ProductFaultsView(model: model) }
            LinkTaskTile(.dashboard) { ProductDashboardView(model: model) }
            LinkTaskTile(.table) { ProductTableView(model: model) }
            LinkTaskTile(.graph) { ProductGraphView(model: model) }
            LinkTaskTile(.tests) { ProductTestsView(model: model) }
            LinkTaskTile(.services) { ProductServicesView(model: model) }
            LinkTaskTile(.settings) { ProductSettingsView(model: model) }
        }
    }
}

private struct ProductVehicleView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                LinkLabeledPanel(title: "Vehicle", systemImage: "car.side.fill") {
                    ProductValueRow(label: "VIN", value: model.vehicleVINText, icon: "number")
                    Divider()
                    ProductValueRow(label: "Diagnostic generation", value: model.diagnosticCapabilityText, icon: "cpu")
                    Divider()
                    ProductValueRow(label: "OBD protocol", value: model.obdProtocolText, icon: "cable.connector")
                }
                LinkLabeledPanel(title: "Saved vehicles", systemImage: "car.2.fill") {
                    if model.savedVehicleProfiles.isEmpty {
                        Text("No saved BMW vehicles yet. A successful live VIN creates the profile automatically.")
                            .font(.subheadline).foregroundStyle(ProductTheme.secondary)
                    } else {
                        ForEach(model.savedVehicleProfiles) { profile in
                            Button { model.selectSavedVehicle(vin: profile.vin) } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(profile.displayName).font(.subheadline.bold()).foregroundStyle(ProductTheme.primary)
                                        Text(profile.vin).font(.caption2.monospaced()).foregroundStyle(ProductTheme.secondary)
                                    }
                                    Spacer()
                                    if profile.vin == model.selectedVehicleVIN {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(ProductTheme.accent)
                                    }
                                }
                            }.buttonStyle(.plain)
                            if profile.id != model.savedVehicleProfiles.last?.id { Divider() }
                        }
                    }
                }
                LinkLabeledPanel(title: "Control units", systemImage: "square.stack.3d.up.fill") {
                    NavigationLink { ProductModulesView(model: model) } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Responder and module inventory").font(.headline).foregroundStyle(ProductTheme.primary)
                                Text("LINK standard responders now; BMW-specific module knowledge remains product-owned.")
                                    .font(.caption).foregroundStyle(ProductTheme.secondary)
                            }
                            Spacer(); Image(systemName: "chevron.right").foregroundStyle(ProductTheme.accent)
                        }
                    }.buttonStyle(.plain)
                }
            }.padding(16)
        }.productDiagnosticScreen("Vehicle")
    }
}

private struct ProductModulesView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Standard responders", systemImage: "square.stack.3d.up.fill") {
                ProductValueRow(label: "Physical responders", value: model.standardResponderSummary, icon: "point.3.connected.trianglepath.dotted")
                Divider()
                ProductValueRow(label: "Advertised parameters", value: model.supportedPIDSummary, icon: "waveform.path.ecg")
                Divider()
                ProductValueRow(label: "Capability", value: model.diagnosticCapabilityText, icon: "cpu")
            }.padding(16)
        }.productDiagnosticScreen("Modules")
    }
}

private struct ProductFaultsView: View {
    @ObservedObject var model: ConnectionViewModel
    private var total: Int { model.storedDTCs.count + model.pendingDTCs.count + model.permanentDTCs.count }
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Errors", systemImage: "exclamationmark.triangle.fill") {
                ProductValueRow(label: "Scan state", value: model.faultScanStatusText, icon: "waveform.path.ecg")
                ProductValueRow(label: "Fault records", value: "\(total)", icon: "exclamationmark.triangle")
                FaultGroup(title: "Stored", values: model.storedDTCs)
                FaultGroup(title: "Pending", values: model.pendingDTCs)
                FaultGroup(title: "Permanent", values: model.permanentDTCs)
            }.padding(16)
        }.productDiagnosticScreen("Errors")
    }
}

private struct ProductTableView: View {
    @ObservedObject var model: ConnectionViewModel
    private var parameters: [LinkDiagnosticParameter] { model.diagnosticParameters.filter(\.vehicleSupported) }
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Table", systemImage: "tablecells") {
                if parameters.isEmpty {
                    Text(model.isActive ? "Waiting for advertised standard parameters." : "Connect to populate supported standard live data.")
                        .font(.subheadline).foregroundStyle(ProductTheme.secondary)
                } else {
                    ForEach(parameters) { parameter in
                        HStack(alignment: .top, spacing: 10) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(parameter.title).font(.subheadline.bold()).foregroundStyle(ProductTheme.primary)
                                Text("\(parameter.presentationValue) · \(parameter.sourceText)")
                                    .font(.caption.monospacedDigit()).foregroundStyle(ProductTheme.secondary)
                            }
                            Spacer()
                            Button { model.toggleFavourite(parameter) } label: {
                                Image(systemName: parameter.favourite ? "star.fill" : "star")
                            }.buttonStyle(.plain).foregroundStyle(ProductTheme.accent)
                            Button { model.togglePolling(parameter) } label: {
                                Image(systemName: parameter.pollingEnabled ? "waveform.path.ecg" : "pause.circle")
                            }.buttonStyle(.plain).foregroundStyle(parameter.pollingEnabled ? ProductTheme.success : ProductTheme.warning)
                        }
                        Divider()
                    }
                }
            }.padding(16)
        }.productDiagnosticScreen("Table")
    }
}

private struct ProductDashboardView: View {
    @ObservedObject var model: ConnectionViewModel
    @AppStorage("link.dashboard.presentationMode") private var dashboardModeKey = LinkDashboardPresentationMode.combined.rawValue
    private var mode: Binding<LinkDashboardPresentationMode> {
        Binding(get: { LinkDashboardPresentationMode(rawValue: dashboardModeKey) ?? .combined },
                set: { dashboardModeKey = $0.rawValue })
    }
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Dashboard", systemImage: "gauge.with.dots.needle.67percent") {
                LinkDashboardModePicker(selection: mode)
                if model.dashboardParameters.isEmpty {
                    Text("No supported live measurements are available for the dashboard yet.")
                        .font(.subheadline).foregroundStyle(ProductTheme.secondary)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                        ForEach(model.dashboardParameters) { parameter in
                            LinkDashboardMetric(parameter: parameter, mode: mode.wrappedValue)
                        }
                    }
                }
            }.padding(16)
        }.productDiagnosticScreen("Dashboard")
    }
}

private struct ProductEvidenceView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Diagnostic evidence", systemImage: "doc.text.magnifyingglass") {
                ProductValueRow(label: "Recorded samples", value: "\(model.recordedSampleCount)", icon: "waveform")
                Button { model.prepareCSVExport() } label: {
                    Label(model.isPreparingCSV ? "Preparing…" : "Prepare evidence CSV", systemImage: "doc.badge.plus")
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                }.buttonStyle(.borderedProminent).tint(ProductTheme.accent).disabled(model.isPreparingCSV)
                if let url = model.csvExportURL {
                    ShareLink(item: url) { Label("Share CSV", systemImage: "square.and.arrow.up").frame(maxWidth: .infinity) }
                        .buttonStyle(.bordered).tint(ProductTheme.accent)
                }
            }.padding(16)
        }.productDiagnosticScreen("Log")
    }
}

private struct ProductGraphView: View {
    @ObservedObject var model: ConnectionViewModel
    private var graphable: [LinkDiagnosticParameter] { model.diagnosticParameters.filter { $0.vehicleSupported && $0.history.count > 1 } }
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Graph", systemImage: "chart.xyaxis.line") {
                if graphable.isEmpty {
                    Text("Collect live samples to populate graphable parameters.").foregroundStyle(ProductTheme.secondary)
                } else {
                    ForEach(graphable.prefix(8)) { parameter in
                        ProductValueRow(label: parameter.title,
                                        value: "\(parameter.history.count) samples · latest \(parameter.presentationValue)",
                                        icon: "waveform")
                        Divider()
                    }
                }
                Text("LINK telemetry history is retained without inventing synthetic samples.")
                    .font(.caption).foregroundStyle(ProductTheme.secondary)
            }.padding(16)
        }.productDiagnosticScreen("Graph")
    }
}

private struct ProductTestsView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                LinkLabeledPanel(title: "Readiness", systemImage: "checkmark.square.fill") {
                    ProductValueRow(label: "Status", value: model.readinessStatusText, icon: "checklist")
                    ForEach(model.readinessMonitorStatus, id: \.self) { Text($0).foregroundStyle(ProductTheme.primary) }
                }
                LinkLabeledPanel(title: "Freeze-frame context", systemImage: "camera.metering.matrix") {
                    if model.freezeFrameContext.isEmpty {
                        Text("No standard freeze-frame context captured.").foregroundStyle(ProductTheme.secondary)
                    } else {
                        ForEach(model.freezeFrameContext, id: \.self) { Text($0).foregroundStyle(ProductTheme.primary) }
                    }
                }
            }.padding(16)
        }.productDiagnosticScreen("Tests")
    }
}

private struct ProductServicesView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            LinkLabeledPanel(title: "Services", systemImage: "wrench.and.screwdriver.fill") {
                Text(model.isActive ? "No verified BMW-specific service procedure is enabled for this session." : "Connect to evaluate supported service procedures.")
                    .font(.headline).foregroundStyle(ProductTheme.primary)
                Text("Manufacturer procedures stay in BMWLINK; reusable execution and safety machinery stays in LINK.")
                    .font(.caption).foregroundStyle(ProductTheme.secondary)
            }.padding(16)
        }.productDiagnosticScreen("Services")
    }
}

private struct ProductSettingsView: View {
    @ObservedObject var model: ConnectionViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                LinkLabeledPanel(title: "BMWLINK", systemImage: "gearshape.fill") {
                    ProductValueRow(label: "Version", value: model.versionText, icon: "number.circle")
                    ProductValueRow(label: "Shared engine", value: "LINK \(model.linkVersionText)", icon: "square.stack.3d.up")
                }
                LinkLabeledPanel(title: "Language", systemImage: "globe") {
                    Picker("Language", selection: Binding(get: { model.selectedLanguageID }, set: { model.selectLanguage($0) })) {
                        ForEach(Array(model.languageTags.indices), id: \.self) { index in
                            Text(index < model.languageNames.count ? model.languageNames[index] : model.languageTags[index]).tag(model.languageTags[index])
                        }
                    }.pickerStyle(.menu)
                }
                LinkLabeledPanel(title: "Unit system", systemImage: "ruler") {
                    Picker("Unit system", selection: Binding(get: { model.selectedMeasurementID }, set: { model.selectMeasurementSystem($0) })) {
                        ForEach(Array(model.measurementKeys.indices), id: \.self) { index in
                            Text(index < model.measurementNames.count ? model.measurementNames[index] : model.measurementKeys[index]).tag(model.measurementKeys[index])
                        }
                    }.pickerStyle(.segmented)
                }
            }.padding(16)
        }.productDiagnosticScreen("Settings")
    }
}

private struct ProductValueRow: View {
    let label: String
    let value: String
    let icon: String
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Image(systemName: icon).foregroundStyle(ProductTheme.accent).frame(width: 18)
            Text(label).font(.caption.bold()).foregroundStyle(ProductTheme.secondary)
            Spacer(minLength: 12)
            Text(value).font(.subheadline).foregroundStyle(ProductTheme.primary).multilineTextAlignment(.trailing)
        }
    }
}

private struct FaultGroup: View {
    let title: String
    let values: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.caption.bold()).foregroundStyle(ProductTheme.secondary)
            if values.isEmpty {
                Text("None reported").font(.subheadline).foregroundStyle(ProductTheme.secondary)
            } else {
                ForEach(values, id: \.self) { Text($0).font(.body.monospaced()).foregroundStyle(ProductTheme.primary) }
            }
        }.padding(.top, 4)
    }
}
