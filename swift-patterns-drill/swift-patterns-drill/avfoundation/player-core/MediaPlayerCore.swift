//
//  MediaPlayerCore.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 01/12/2025.
//

//
//  MediaPlayerCore.swift
//
//  Analogy (AVFoundation):
//  - AVURLAsset  = raw fuel (media on disk / network)
//  - AVPlayerItem = fuel processor (prepares a single asset for playback)
//  - AVPlayer     = rocket engine (actually plays the prepared item)
//
//  Here we build a tiny wrapper that expresses this clearly in code,
//  and exposes a simple state enum you could bind to a UI or ViewModel.
//

import Foundation
import AVFoundation

// MARK: - Player State

enum MediaPlayerState: Equatable {
    case idle
    case loading(URL)
    case ready(URL)
    case playing(URL)
    case paused(URL)
    case failed(String)
}

// MARK: - Engine Protocol (good for testability)

protocol MediaPlayerEngine {
    func load(url: URL)
    func play()
    func pause()
}

/// Concrete engine backed by AVPlayer. This is the AVFoundation-specific bit.
final class AVPlayerEngine: MediaPlayerEngine {

    private let player = AVPlayer()
    private(set) var currentURL: URL?

    func load(url: URL) {
        currentURL = url

        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)

        // Asset (fuel) → PlayerItem (fuel processor) → Player (engine)
        player.replaceCurrentItem(with: item)
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }
}

// MARK: - Player Controller (framework-agnostic, good for MVVM)

final class MediaPlayerController {

    private let engine: MediaPlayerEngine

    private(set) var state: MediaPlayerState = .idle {
        didSet { onStateChange?(state) }
    }

    /// Callback whenever state changes — UI or tests can hook into this.
    var onStateChange: ((MediaPlayerState) -> Void)?

    init(engine: MediaPlayerEngine) {
        self.engine = engine
    }

    func load(url: URL) {
        state = .loading(url)
        engine.load(url: url)
        state = .ready(url)
    }

    func play(url: URL? = nil) {
        if let url {
            load(url: url)
        }

        switch state {
        case .ready(let url),
             .paused(let url):
            engine.play()
            state = .playing(url)
        default:
            break
        }
    }

    func pause() {
        switch state {
        case .playing(let url):
            engine.pause()
            state = .paused(url)
        default:
            break
        }
    }

    func fail(with message: String) {
        state = .failed(message)
    }
}

// MARK: - Demo (Playground / breakpoints)

/// ```swift
/// demoMediaPlayer()
/// ```
func demoMediaPlayer() {
    guard let url = URL(string: "https://example.com/media.mp4") else {
        print("Invalid URL")
        return
    }

    let engine = AVPlayerEngine()
    let controller = MediaPlayerController(engine: engine)

    controller.onStateChange = { state in
        print("Player state:", state)
    }

    controller.play(url: url)
    controller.pause()
}
