import Foundation
import AppKit

@MainActor
class ClipboardMonitor: ObservableObject {
    @Published var items: [ClipboardItem] = []
    private var pasteboard = NSPasteboard.general
    private var changeCount: Int
    private var timer: Timer?
    private let maxItems = 100
    
    init() {
        print("  🔧 ClipboardMonitor.init - start")
        self.changeCount = pasteboard.changeCount
        print("  🔧 Loading history...")
        loadHistory()
        print("  🔧 Starting monitoring...")
        startMonitoring()
        print("  ✅ ClipboardMonitor.init - complete")
    }
    
    func startMonitoring() {
        // TODO: Fix timer crash
        // timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
        //     self?.checkForChanges()
        // }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForChanges() {
        guard pasteboard.changeCount != changeCount else { return }
        changeCount = pasteboard.changeCount
        
        if let string = pasteboard.string(forType: .string), !string.isEmpty {
            addItem(content: string)
        }
    }
    
    func addItem(content: String) {
        // Evita duplicati consecutivi
        if let lastItem = items.first(where: { !$0.isPinned }), lastItem.content == content {
            return
        }
        
        let newItem = ClipboardItem(content: content)
        items.insert(newItem, at: 0)
        
        // Limita il numero di elementi non pinnati
        let unpinnedCount = items.filter { !$0.isPinned }.count
        if unpinnedCount > maxItems {
            // Rimuovi gli elementi non pinnati più vecchi
            let pinnedItems = items.filter { $0.isPinned }
            let unpinnedItems = items.filter { !$0.isPinned }.prefix(maxItems)
            items = pinnedItems + unpinnedItems
        }
        
        saveHistory()
    }
    
    func copyToClipboard(_ item: ClipboardItem) {
        pasteboard.clearContents()
        pasteboard.setString(item.content, forType: .string)
        changeCount = pasteboard.changeCount
    }
    
    func deleteItem(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
        saveHistory()
    }
    
    func togglePin(_ item: ClipboardItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPinned.toggle()
            saveHistory()
        }
    }
    
    func clearHistory() {
        items.removeAll()
        saveHistory()
    }
    
    func searchItems(query: String) -> [ClipboardItem] {
        let filtered = query.isEmpty ? items : items.filter { $0.content.localizedCaseInsensitiveContains(query) }
        // Ordina: pinnati prima, poi per data
        return filtered.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned {
                return lhs.isPinned
            }
            return lhs.timestamp > rhs.timestamp
        }
    }
    
    // MARK: - Persistenza
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "clipboardHistory")
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "clipboardHistory"),
           let decoded = try? JSONDecoder().decode([ClipboardItem].self, from: data) {
            items = decoded
        }
    }
}
