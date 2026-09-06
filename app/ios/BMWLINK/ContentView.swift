// SPDX-License-Identifier: GPL-3.0-or-later
import SwiftUI

private let productTheme = LinkDiagnosticTheme(
    backgroundTop: Color(red: 0.02, green: 0.035, blue: 0.055),
    backgroundMiddle: Color(red: 0.035, green: 0.065, blue: 0.095),
    backgroundBottom: Color(red: 0.055, green: 0.09, blue: 0.13),
    panel: Color(red: 0.055, green: 0.09, blue: 0.13),
    panelRaised: Color(red: 0.075, green: 0.14, blue: 0.20),
    primaryText: Color(red: 0.95, green: 0.97, blue: 1.0),
    secondaryText: Color(red: 0.59, green: 0.70, blue: 0.80),
    mutedText: Color(red: 0.59, green: 0.70, blue: 0.80).opacity(0.72),
    border: Color(red: 0.16, green: 0.32, blue: 0.47).opacity(0.72),
    accent: Color(red: 0.11, green: 0.41, blue: 0.83),
    success: Color(red: 0.34, green: 0.78, blue: 0.48),
    warning: Color(red: 0.95, green: 0.68, blue: 0.25),
    fault: Color(red: 0.90, green: 0.22, blue: 0.28),
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

private let productAppearance = LinkStandardProductAppearance(
    productName: "BMWLINK",
    manufacturerName: "BMW",
    subtitle: "BMW · LINK DIAGNOSTICS",
    emblemAssetName: "BMWLINKEmblem",
    theme: productTheme,
    summary: "Open-source BMW diagnostics built as a branded product face on the shared LINK engine.",
    authors: ["Shannon Smith"],
    copyrightShort: "© 2026 Shannon Smith",
    copyrightFull: "Copyright © 2026 Shannon Smith",
    website: URL(string: "https://github.com/Infiltrator-Projects/BMWLink"),
    licenseName: "GPL-3.0-or-later",
    licenseText: "BMWLINK is free software licensed under GNU GPL v3 or later. See LICENSE in the source package for the complete licence text.",
    credits: ["Shannon Smith — Author and project maintainer"])

struct ContentView: View {
    @StateObject private var model = ConnectionViewModel()

    var body: some View {
        LinkStandardProductContentView(
            model: model,
            appearance: productAppearance)
    }
}
