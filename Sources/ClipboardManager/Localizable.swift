import Foundation

enum L10n {
    // Header
    static let appTitle = NSLocalizedString("app.title", comment: "Application title")
    static let clearHistory = NSLocalizedString("clear.history", comment: "Clear history tooltip")
    static let quit = NSLocalizedString("quit", comment: "Quit tooltip")
    
    // Search
    static let search = NSLocalizedString("search", comment: "Search placeholder")
    
    // Empty states
    static let emptyHistory = NSLocalizedString("empty.history", comment: "Empty history message")
    static let noResults = NSLocalizedString("no.results", comment: "No search results message")
    
    // Footer
    static func itemsCount(_ count: Int) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("items.count", comment: "Items count"),
            count
        )
    }
    static let hotkeyHint = NSLocalizedString("hotkey.hint", comment: "Hotkey hint")
    
    // Item actions
    static let copy = NSLocalizedString("copy", comment: "Copy tooltip")
    static let delete = NSLocalizedString("delete", comment: "Delete tooltip")
    static let pin = NSLocalizedString("pin", comment: "Pin tooltip")
    static let unpin = NSLocalizedString("unpin", comment: "Unpin tooltip")
}
