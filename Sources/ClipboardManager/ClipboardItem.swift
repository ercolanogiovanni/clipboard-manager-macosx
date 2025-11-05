import Foundation

struct ClipboardItem: Codable, Identifiable, Equatable {
    let id: UUID
    let content: String
    let timestamp: Date
    let preview: String
    var isPinned: Bool
    
    init(content: String, isPinned: Bool = false) {
        self.id = UUID()
        self.content = content
        self.timestamp = Date()
        self.preview = String(content.prefix(100))
        self.isPinned = isPinned
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
