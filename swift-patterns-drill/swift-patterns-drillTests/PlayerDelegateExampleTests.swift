//
//  PlayerDelegateExampleTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

// MARK: - Mock Delegate

private final class MockPlayerDelegate: PlayerDelegate {

    enum Event: Equatable {
        case didStart
        case didPause
        case didFinish
    }

    private(set) var events: [Event] = []

    func playerDidStart(_ player: Player) {
        events.append(.didStart)
    }

    func playerDidPause(_ player: Player) {
        events.append(.didPause)
    }

    func playerDidFinish(_ player: Player) {
        events.append(.didFinish)
    }
}

// MARK: - Tests

final class PlayerDelegateExampleTests: XCTestCase {

    func testPlayerNotifiesDelegateOnPlayPauseStop() {
        let player = Player()
        let mockDelegate = MockPlayerDelegate()
        player.delegate = mockDelegate

        player.play()
        player.pause()
        player.play()
        player.stop()

        XCTAssertEqual(
            mockDelegate.events,
            [.didStart, .didPause, .didStart, .didFinish]
        )
    }

    func testPlayerDoesNotSendDuplicateStartEventsWhenAlreadyPlaying() {
        let player = Player()
        let mockDelegate = MockPlayerDelegate()
        player.delegate = mockDelegate

        player.play()
        player.play()  // Should be ignored

        XCTAssertEqual(mockDelegate.events, [.didStart])
    }

    func testPlayerIgnoresPauseAndStopWhenNotPlaying() {
        let player = Player()
        let mockDelegate = MockPlayerDelegate()
        player.delegate = mockDelegate

        player.pause()
        player.stop()

        XCTAssertTrue(mockDelegate.events.isEmpty)
    }
}
