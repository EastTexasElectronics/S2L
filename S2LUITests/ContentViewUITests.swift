import XCTest

class ContentViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        
        // Add SVG directory
        addSVGDirectory()
    }
    
    func addSVGDirectory() {
        let browseButtons = app.buttons.matching(identifier: "Browse")
        XCTAssertEqual(browseButtons.count, 2, "Expected two Browse buttons")
        
        let inputBrowseButton = browseButtons.element(boundBy: 0)
        inputBrowseButton.tap()
        
        // Simulate directory selection
        let svgDirectoryPath = "/Users/rmh/desktop/SVG"
        let openPanel = app.dialogs["Open"]
        
        // Wait for the Open panel to appear
        XCTAssertTrue(openPanel.waitForExistence(timeout: 5))
        
        // Type the directory path
        openPanel.typeKey(.delete, modifierFlags: .command) // Clear any existing text
        openPanel.typeText(svgDirectoryPath)
        openPanel.typeKey(.return, modifierFlags: [])

        // Give things time to load
        sleep(2)

        // Select the file manager open button
        openPanel.buttons["Open"].tap()
        
        // Wait for the files to be loaded
        let filesTable = app.tables["List of all files."]
        XCTAssertTrue(filesTable.waitForExistence(timeout: 5))
    }
    
    func testHeaderViewElements() throws {
        XCTAssertTrue(app.images["S2L Banner Logo"].exists)
        XCTAssertTrue(app.buttons["questionmark.circle"].exists)
        XCTAssertTrue(app.buttons["info.circle"].exists)
    }
    
    func testDirectorySelectionViews() throws {
        XCTAssertTrue(app.staticTexts["Add Your SVG's:"].exists)
        XCTAssertTrue(app.staticTexts["Output Location:"].exists)
        XCTAssertEqual(app.buttons.matching(identifier: "Browse").count, 2)
    }
    
    func testFilesHeaderView() throws {
        XCTAssertTrue(app.buttons["Select All"].exists)
        XCTAssertTrue(app.staticTexts["Files"].exists)
        XCTAssertTrue(app.staticTexts["viewBox"].exists)
        XCTAssertTrue(app.staticTexts["Class"].exists)
        XCTAssertTrue(app.staticTexts["Fill"].exists)
        XCTAssertTrue(app.staticTexts["Prefix"].exists)
    }
    
    func testFilesList() throws {
        let filesTable = app.tables["List of all files."]
        XCTAssertTrue(filesTable.exists)
        XCTAssertGreaterThan(filesTable.cells.count, 0, "Expected at least one file in the list")
    }
    
    func testActionButtons() throws {
        XCTAssertTrue(app.buttons["Remove Selected"].exists)
        XCTAssertTrue(app.buttons["Bulk Edit"].exists)
        XCTAssertTrue(app.buttons["Convert"].exists)
    }
    
    func testHelpModalPresentation() throws {
        app.buttons["questionmark.circle"].tap()
        XCTAssertTrue(app.sheets["Help"].waitForExistence(timeout: 5))
    }
    
    func testAboutModalPresentation() throws {
        app.buttons["info.circle"].tap()
        XCTAssertTrue(app.sheets["About"].waitForExistence(timeout: 5))
    }
    
    func testBulkEditModalPresentation() throws {
        let filesTable = app.tables["List of all files."]
        XCTAssertGreaterThan(filesTable.cells.count, 0, "Expected at least one file in the list")
        
        filesTable.cells.element(boundBy: 0).tap()
        app.buttons["Bulk Edit"].tap()
        XCTAssertTrue(app.sheets["Bulk Edit"].waitForExistence(timeout: 5))
    }
    
    func testFileSelection() throws {
        let filesTable = app.tables["List of all files."]
        XCTAssertGreaterThan(filesTable.cells.count, 0, "Expected at least one file in the list")
        
        let firstFile = filesTable.cells.element(boundBy: 0)
        firstFile.tap()
        XCTAssertTrue(firstFile.isSelected)
    }
    
    func testRemoveSelectedFiles() throws {
        let filesTable = app.tables["List of all files."]
        let initialFileCount = filesTable.cells.count
        XCTAssertGreaterThan(initialFileCount, 0, "Expected at least one file in the list")
        
        filesTable.cells.element(boundBy: 0).tap()
        app.buttons["Remove Selected"].tap()
        
        let newFileCount = filesTable.cells.count
        XCTAssertEqual(newFileCount, initialFileCount - 1, "Expected one less file after removal")
    }
    
    func testConvertButton() throws {
        app.buttons["Convert"].tap()
        XCTAssertTrue(app.sheets["Progress"].waitForExistence(timeout: 5))
    }
}
