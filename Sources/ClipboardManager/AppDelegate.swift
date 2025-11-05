import AppKit

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var monitor: ClipboardMonitor?
    var hotKeyManager: HotKeyManager?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ App launched")
        
        print("📋 Creating ClipboardMonitor...")
        monitor = ClipboardMonitor()
        print("✅ ClipboardMonitor created")
        
        print("📊 Creating StatusBarController...")
        if let monitor = monitor {
            statusBarController = StatusBarController(monitor: monitor)
            print("✅ StatusBarController created")
        }
        
        print("✅ All components initialized")
    }
    
    nonisolated private func requestAccessibilityPermissions() {
        let prompt = "kAXTrustedCheckOptionPrompt" as CFString
        let options: NSDictionary = [prompt: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("⚠️ Accessibility permissions needed for global hotkey")
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        monitor?.stopMonitoring()
        hotKeyManager?.unregister()
    }
}
