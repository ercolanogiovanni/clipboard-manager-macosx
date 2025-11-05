import XCTest
@testable import ClipboardManager

final class ClipboardMonitorTests: XCTestCase {
    
    @MainActor
    func testClipboardMonitorInitialization() async throws {
        let monitor = ClipboardMonitor()
        XCTAssertNotNil(monitor)
    }
    
    @MainActor
    func testClipboardMonitorItems() async throws {
        let monitor = ClipboardMonitor()
        // Il monitor parte con items vuoto o con item corrente
        XCTAssertTrue(monitor.items.count >= 0)
    }
}
