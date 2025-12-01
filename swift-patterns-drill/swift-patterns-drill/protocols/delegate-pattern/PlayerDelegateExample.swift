//
//  PlayerDelegateExample.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  PlayerDelegateExample.swift
//
//  Analogy:
//  - A delegate is like a commentator for a football match.
//    The player (match) doesn’t know *who* is listening,
//    it just calls methods on its commentator when things happen:
//
//      - matchStarted()
//      - matchPaused()
//      - matchFinished()
//
//  The delegate pattern lets one object report events back to another,
//  without creating a tight coupling between them.
//

import Foundation

// MARK: - Delegate Protocol

protocol PlayerDelegate: AnyObject {
    func playerDidStart(_ player: Player)
    func playerDidPause(_ player: Player)
    func playerDidFinish(_ player: Player)
}

// MARK: - Player

final class Player {

    weak var delegate: PlayerDelegate?

    private(set) var isPlaying: Bool = false

    func play() {
        guard !isPlaying else { return }
        isPlaying = true
        delegate?.playerDidStart(self)
    }

    func pause() {
        guard isPlaying else { return }
        isPlaying = false
        delegate?.playerDidPause(self)
    }

    func stop() {
        guard isPlaying else { return }
        isPlaying = false
        delegate?.playerDidFinish(self)
    }
}

// MARK: - Example Delegate Implementation

/// A simple logger that conforms to PlayerDelegate.
/// In a real app, this could be a ViewController updating the UI.
final class PlayerLogger: PlayerDelegate {

    func playerDidStart(_ player: Player) {
        print("▶️ Player started")
    }

    func playerDidPause(_ player: Player) {
        print("⏸ Player paused")
    }

    func playerDidFinish(_ player: Player) {
        print("⏹ Player finished")
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call from the playground:
///
/// ```swift
/// demoPlayerDelegate()
/// ```
func demoPlayerDelegate() {
    let player = Player()
    let logger = PlayerLogger()

    player.delegate = logger

    player.play()
    player.pause()
    player.play()
    player.stop()
}
