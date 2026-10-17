// MovieNightUITests.swift
// One happy-path test that drives the real app with the Siri Remote:
// start, vote Yes on every movie for both default players, then check a winner is shown.

import XCTest

final class MovieNightUITests: XCTestCase {

    private let remote = XCUIRemote.shared
    private let playerCount = 2       // the app starts with two players
    private let moviesPerPlayer = 8   // MovieNightViewModel's default

    override func setUp() {
        continueAfterFailure = false
    }

    func testFullVoteShowsWinner() {
        let app = XCUIApplication()
        app.launch()

        let startButton = app.buttons["startVotingButton"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5))
        moveFocus(to: startButton)
        remote.press(.select)

        for _ in 0..<playerCount {
            let readyButton = app.buttons["readyButton"]
            XCTAssertTrue(readyButton.waitForExistence(timeout: 5))
            moveFocus(to: readyButton)
            remote.press(.select)

            let yesButton = app.buttons["yesButton"]
            XCTAssertTrue(yesButton.waitForExistence(timeout: 5))
            for _ in 0..<moviesPerPlayer {
                moveFocus(to: yesButton)
                remote.press(.select)
                sleep(1)   // let the slide animation finish before the next press
            }
        }

        // The reveal waits about one second, so allow some extra time.
        XCTAssertTrue(app.staticTexts["winnerTitle"].waitForExistence(timeout: 10))
    }

    /// Presses down, then right, until the element has focus.
    /// tvOS has no tapping, so this is how the test "reaches" a button.
    // MAC-CHECK: if focus starts somewhere unexpected, adjust the directions here.
    private func moveFocus(to element: XCUIElement) {
        for _ in 0..<6 where !element.hasFocus {
            remote.press(.down)
        }
        for _ in 0..<6 where !element.hasFocus {
            remote.press(.right)
        }
    }
}
