import AppKit
import SwiftUI

@MainActor
class StatusBarController {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var monitor: ClipboardMonitor
    private var launchAtLoginManager: LaunchAtLoginManager
    private var popoverWindow: NSWindow?
    
    init(monitor: ClipboardMonitor, launchAtLoginManager: LaunchAtLoginManager) {
        print("  🔧 StatusBarController.init - start")
        self.monitor = monitor
        self.launchAtLoginManager = launchAtLoginManager
        print("  🔧 Creating statusItem...")
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        print("  🔧 Creating popover...")
        self.popover = NSPopover()
        
        print("  🔧 Setting up status item...")
        setupStatusItem()
        print("  ✅ StatusBarController.init - complete")
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Clipboard Manager")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
    
    private func setupPopover() {
        popover.contentSize = NSSize(width: 400, height: 500)
        popover.behavior = .semitransient
    }
    
    private func ensureContentViewController() {
        // Setup popover settings if not done yet
        if popover.contentSize == .zero {
            setupPopover()
        }
        
        if popover.contentViewController == nil {
            popover.contentViewController = NSHostingController(
                rootView: ContentView(
                    monitor: monitor,
                    launchAtLoginManager: launchAtLoginManager,
                    closePopover: { [weak self] in
                        self?.closePopover()
                    }
                )
            )
        }
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopoverAtCursor()
        }
    }
    
    func showPopover() {
        ensureContentViewController()
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    
    func showPopoverAtCursor() {
        // Chiudi popover esistente se aperto e pulisci la finestra precedente
        if popover.isShown {
            closePopover()
            return
        }
        
        // Setup popover on first use
        if popover.contentViewController == nil {
            setupPopover()
        }
        
        // Pulisci eventuali finestre precedenti
        if let oldWindow = popoverWindow {
            oldWindow.orderOut(nil)
            popoverWindow = nil
        }
        
        // Ottieni lo schermo principale o quello con il mouse
        guard let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        
        // Calcola il centro dello schermo
        let screenFrame = screen.visibleFrame
        let centerX = screenFrame.midX
        let centerY = screenFrame.midY
        
        // Crea una finestra invisibile al centro dello schermo
        let rect = NSRect(x: centerX, y: centerY, width: 1, height: 1)
        let window = NSWindow(contentRect: rect, styleMask: .borderless, backing: .buffered, defer: false)
        window.backgroundColor = .clear
        window.isOpaque = false
        window.level = .floating
        window.isReleasedWhenClosed = false
        
        // Salva riferimento alla finestra PRIMA di mostrarla
        popoverWindow = window
        
        window.makeKeyAndOrderFront(nil)
        
        // Mostra il popover relativo alla finestra
        ensureContentViewController()
        if let contentView = window.contentView {
            popover.show(relativeTo: contentView.bounds, of: contentView, preferredEdge: .minY)
        }
    }
    
    func closePopover() {
        popover.performClose(nil)
        // Aspetta che l'animazione finisca prima di nascondere la finestra
        if let window = popoverWindow {
            popoverWindow = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                window.orderOut(nil)
            }
        }
    }
}
