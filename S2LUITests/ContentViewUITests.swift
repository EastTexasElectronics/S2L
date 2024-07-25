import XCTest

final class ContentViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }


    func testClearAllFiles() {
        let clearAllButton = app.buttons["Clear All"]
        XCTAssertTrue(clearAllButton.exists)
        clearAllButton.tap()
        
        // Check that the file list is empty
        let fileList = app.tables["FilesList"]
        XCTAssertEqual(fileList.cells.count, 0)
    }

    func testBulkEdit() {
        let bulkEditButton = app.buttons["Bulk Edit"]
        XCTAssertTrue(bulkEditButton.exists)
        bulkEditButton.tap()
        
        // Check that the bulk edit modal is shown
        // Note: Add actual UI interaction code here if possible.
    }

}
