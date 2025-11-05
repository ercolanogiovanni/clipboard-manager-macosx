import Foundation
import ServiceManagement

@MainActor
class LaunchAtLoginManager: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            setLaunchAtLogin(isEnabled)
        }
    }
    
    init() {
        self.isEnabled = SMAppService.mainApp.status == .enabled
    }
    
    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                if SMAppService.mainApp.status == .enabled {
                    return
                }
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
        }
    }
}
