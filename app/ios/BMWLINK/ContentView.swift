// SPDX-License-Identifier: GPL-3.0-or-later
import SwiftUI

private enum ProductTheme {
    static let backgroundTop = Color(red: 0.02, green: 0.035, blue: 0.055)
    static let backgroundBottom = Color(red: 0.055, green: 0.09, blue: 0.13)
    static let panel = Color(red: 0.055, green: 0.09, blue: 0.13)
    static let border = Color(red: 0.16, green: 0.32, blue: 0.47)
    static let accent = Color(red: 0.11, green: 0.41, blue: 0.83)
    static let primary = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let secondary = Color(red: 0.59, green: 0.70, blue: 0.80)
}

private struct Panel<Content: View>: View {
    let title: String
    let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline).foregroundStyle(ProductTheme.primary)
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(ProductTheme.panel))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(ProductTheme.border))
    }
}

struct ContentView: View {
    @StateObject private var model = ConnectionViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [ProductTheme.backgroundTop, ProductTheme.backgroundBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("BMWLINK").font(.largeTitle.bold()).foregroundStyle(ProductTheme.primary)
                                Text("BMW diagnostics · LINK standards core").foregroundStyle(ProductTheme.secondary)
                            }
                            Spacer()
                            Text(model.versionText).font(.caption.monospaced()).foregroundStyle(ProductTheme.secondary)
                        }

                        Panel("Connection") {
                            Text(model.statusText)
                            Text(model.peripheralName).foregroundStyle(ProductTheme.secondary)
                            Text(model.adapterIdentifier).font(.caption.monospaced()).foregroundStyle(ProductTheme.secondary)
                            Button(model.isActive ? "Disconnect" : "Connect") {
                                model.isActive ? model.disconnect() : model.connect()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(ProductTheme.accent)
                        }

                        Panel("Vehicle") {
                            Text("VIN").font(.caption).foregroundStyle(ProductTheme.secondary)
                            Text(model.vehicleVINText).font(.body.monospaced())
                            Text("Readiness").font(.caption).foregroundStyle(ProductTheme.secondary)
                            Text(model.readinessStatusText)
                        }

                        Panel("Fault memory") {
                            Text(model.faultScanStatusText).foregroundStyle(ProductTheme.secondary)
                            faultGroup("Stored", model.storedDTCs)
                            faultGroup("Pending", model.pendingDTCs)
                            faultGroup("Permanent", model.permanentDTCs)
                        }

                        Panel("Live data") {
                            if model.standardLiveRows.isEmpty {
                                Text("Waiting for advertised SAE live parameters.").foregroundStyle(ProductTheme.secondary)
                            } else {
                                ForEach(model.standardLiveRows, id: \.self) { row in
                                    Text(row).font(.subheadline.monospacedDigit())
                                    Divider().overlay(ProductTheme.border)
                                }
                            }
                        }

                        Panel("Evidence") {
                            Text("\(model.recordedSampleCount) samples recorded")
                            Button("Prepare diagnostic evidence CSV") { model.prepareCSVExport() }
                                .tint(ProductTheme.accent)
                            if let url = model.csvExportURL {
                                ShareLink(item: url) {
                                    Label("Share CSV", systemImage: "square.and.arrow.up")
                                }
                                .tint(ProductTheme.accent)
                            }
                        }
                    }
                    .padding()
                }
            }
            .foregroundStyle(ProductTheme.primary)
            .tint(ProductTheme.accent)
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private func faultGroup(_ title: String, _ values: [String]) -> some View {
        Text(title).font(.caption.bold()).foregroundStyle(ProductTheme.secondary)
        if values.isEmpty {
            Text("None reported").foregroundStyle(ProductTheme.secondary)
        } else {
            ForEach(values, id: \.self) { Text($0).font(.body.monospaced()) }
        }
    }
}
