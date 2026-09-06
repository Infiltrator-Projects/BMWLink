// SPDX-License-Identifier: GPL-3.0-or-later
import Foundation

/** BMW identity and delegate binding over LINK's shared standard app model. */
@MainActor
final class ConnectionViewModel: LinkStandardProductViewModel,
    @preconcurrency BmwLinkDiagnosticsControllerDelegate {

    private let bmwController: BmwLinkDiagnosticsController

    init() {
        let controller = BmwLinkDiagnosticsController()
        self.bmwController = controller
        let version: String
        if let value = bmwlink_version() {
            version = String(cString: value)
        } else {
            version = "Unknown"
        }
        super.init(
            controller: controller,
            configuration: LinkStandardProductConfiguration(
                productName: "BMWLINK",
                productNamespace: "bmwlink",
                manufacturerName: "BMW",
                vehicleName: "BMW vehicle",
                versionText: version))
        controller.delegate = self
    }

    func diagnosticsControllerDidUpdate(
        _ controller: BmwLinkDiagnosticsController
    ) {
        refreshStandardState()
    }
}
