import XCTest

class HelpViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testGitHubButton() {
        let app = XCUIApplication()
        app.buttons["HelpButton"].tap() // Use the new button to open HelpVie
        let gitHubButton = app.buttons["GitHubButton"]
        XCTAssertTrue(gitHubButton.waitForExistence(timeout: 5))
        gitHubButton.tap()
        // Verify GitHub page is opened, if possible
    }

    func testSupportButton() {
        let app = XCUIApplication()
        app.buttons["HelpButton"].tap() // Use the new button to open HelpView
        let supportButton = app.buttons["SupportButton"]
        XCTAssertTrue(supportButton.waitForExistence(timeout: 5))
        supportButton.tap()
        // Verify email client is opened, if possible
    }

    func testCloseButton() {
        let app = XCUIApplication()
        app.buttons["HelpButton"].tap() // Use the new button to open HelpView
        let closeButton = app.buttons["CloseButton"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 5))
        closeButton.tap()
        // Verify that HelpView is dismissed
    }
}
