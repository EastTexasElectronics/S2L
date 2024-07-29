import XCTest

class S2LUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddSVGFiles() throws {
        let app = XCUIApplication()

        // Simulate browsing for SVG input directory
        let addSvgButton = app.buttons["Browse"]
        addSvgButton.firstMatch.tap()

        // Assuming a modal opens to select directory
        let fileDialog = app.dialogs.firstMatch
        let svgDirectory = "/Users/rmh/desktop/svg"
        fileDialog.textFields["Directory"].typeText(svgDirectory)
        fileDialog.buttons["Open"].click()

        // Verify that files have been added
        let filesList = app.tables["List of all files."]
        XCTAssert(filesList.cells.count > 0, "SVG files should be listed after directory is added")
    }

    func testStartConversion() throws {
        let app = XCUIApplication()

        // Simulate browsing for SVG input directory
        let addSvgButton = app.buttons["Browse"]
        addSvgButton.firstMatch.tap()

        // Assuming a modal opens to select directory
        let fileDialog = app.dialogs.firstMatch
        let svgDirectory = "/Users/rmh/desktop/svg"
        fileDialog.textFields["Directory"].typeText(svgDirectory)
        fileDialog.buttons["Open"].click()

        // Start conversion
        let convertButton = app.buttons["Convert"]
        convertButton.tap()

        // Verify that progress view is displayed
        let progressView = app.windows["S2L Terminal"]
        XCTAssert(progressView.exists, "Progress view should be displayed after starting conversion")
    }

    func testVerifyProgress() throws {
        let app = XCUIApplication()

        // Simulate browsing for SVG input directory
        let addSvgButton = app.buttons["Browse"]
        addSvgButton.firstMatch.tap()

        // Assuming a modal opens to select directory
        let fileDialog = app.dialogs.firstMatch
        let svgDirectory = "/Users/rmh/desktop/svg"
        fileDialog.textFields["Directory"].typeText(svgDirectory)
        fileDialog.buttons["Open"].click()

        // Start conversion
        let convertButton = app.buttons["Convert"]
        convertButton.tap()

        // Verify that progress view is displayed
        let progressView = app.windows["S2L Terminal"]
        XCTAssert(progressView.exists, "Progress view should be displayed after starting conversion")

        // Verify log messages
        let logTextView = progressView.textViews.firstMatch
        let logText = logTextView.value as! String
        XCTAssert(logText.contains("Success: Converted file"), "Log should contain success message for file conversion")
    }
}
