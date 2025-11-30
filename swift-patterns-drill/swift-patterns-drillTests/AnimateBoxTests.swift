//
//  AnimateBoxTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

final class AnimateBoxTests: XCTestCase {

    func testAnimateCallsAnimationsBeforeCompletion() {
        var events: [String] = []

        BoxAnimator.animate(duration: 0.3, animations: {
            events.append("animations")
        }) {
            events.append("completion")
        }

        XCTAssertEqual(events, ["animations", "completion"])
    }

    func testAnimateWorksWithoutCompletion() {
        var wasCalled = false

        BoxAnimator.animate(duration: 0.1, animations: {
            wasCalled = true
        }, completion: nil)

        XCTAssertTrue(wasCalled)
    }
}
