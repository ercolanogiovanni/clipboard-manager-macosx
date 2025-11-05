import SwiftUI

struct ContentView: View {
    @ObservedObject var monitor: ClipboardMonitor
    @State private var searchText = ""
    var closePopover: () -> Void
    
    var filteredItems: [ClipboardItem] {
        monitor.searchItems(query: searchText)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(L10n.appTitle)
                    .font(.headline)
                Spacer()
                Button(action: {
                    monitor.clearHistory()
                }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
                .help(L10n.clearHistory)
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "xmark.circle")
                }
                .buttonStyle(.plain)
                .help(L10n.quit)
            }
            .padding()
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField(L10n.search, text: $searchText)
                    .textFieldStyle(.plain)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Divider()
            
            // Lista elementi
            if filteredItems.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text(searchText.isEmpty ? L10n.emptyHistory : L10n.noResults)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredItems) { item in
                            ClipboardItemRow(item: item, monitor: monitor, closePopover: closePopover)
                            if item.id != filteredItems.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
            
            Divider()
            
            // Footer
            HStack {
                Text(L10n.itemsCount(filteredItems.count))
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(L10n.hotkeyHint)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(8)
        }
        .frame(width: 400, height: 500)
    }
}

struct ClipboardItemRow: View {
    let item: ClipboardItem
    @ObservedObject var monitor: ClipboardMonitor
    var closePopover: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.preview)
                    .lineLimit(3)
                    .font(.body)
                Text(item.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isHovered || item.isPinned {
                HStack(spacing: 8) {
                    Button(action: {
                        monitor.togglePin(item)
                    }) {
                        Image(systemName: item.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(item.isPinned ? .orange : .gray)
                    }
                    .buttonStyle(.plain)
                    .help(item.isPinned ? L10n.unpin : L10n.pin)
                    
                    Button(action: {
                        monitor.copyToClipboard(item)
                        closePopover()
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    .buttonStyle(.plain)
                    .help(L10n.copy)
                    
                    if !item.isPinned {
                        Button(action: {
                            monitor.deleteItem(item)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                        .help(L10n.delete)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isHovered ? Color(NSColor.controlAccentColor).opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            monitor.copyToClipboard(item)
            closePopover()
        }
    }
}
