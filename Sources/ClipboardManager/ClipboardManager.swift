import AppKit

@MainActor
@main
class ClipboardManagerApp: NSObject, NSApplicationDelegate {
    nonisolated(unsafe) static var instance: ClipboardManagerApp?
    
    var statusBarController: StatusBarController?
    var monitor: ClipboardMonitor?
    var hotKeyManager: HotKeyManager?
    
    static func main() {
        let app = NSApplication.shared
        instance = ClipboardManagerApp()
        app.delegate = instance
        app.setActivationPolicy(.accessory)
        app.run()
    }
    
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
        
        print("⌨️  Registering hotkey (Cmd+Shift+V)...")
        hotKeyManager = HotKeyManager { [weak self] in
            print("🔥 Hotkey pressed!")
            self?.statusBarController?.showPopoverAtCursor()
        }
        hotKeyManager?.register()
        print("✅ Hotkey registered")
        
        print("✅ All components initialized")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        monitor?.stopMonitoring()
        hotKeyManager?.unregister()
    }
}
