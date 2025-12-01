// ⌘
//
//  GymCat/GymCatUITests/GymCatUITestsLaunchTests.swift
//
//  Created by @jonathaxs on 2025-08-16.
//
// ⌘

import XCTest

final class GymCatUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
