//
//  AnimateBox.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  AnimateBox.swift
//
//  Analogy:
//  - A trailing closure is like writing a post-it note *after* the instruction.
//    Instead of cramming everything inside the brackets, you say:
//
//      doSomething() {
//          // extra behaviour
//      }
//
//  In UIKit, you see this all the time with UIView.animate, URLSession, etc.
//  The closure “trails” after the function call, making the code easier to read.
//

import Foundation

// MARK: - Animation Logic (UI-agnostic for testing)

struct BoxAnimator {

    /// Core animation function. In a real app, this would wrap UIView.animate.
    /// Here, we just:
    ///   1. Run the `animations` closure
    ///   2. Then call `completion` (if any)
    ///
    /// Trailing-closure usage example:
    ///
    ///     BoxAnimator.animate(duration: 0.3, animations: {
    ///         print("Moving box...")
    ///     }) {
    ///         print("Animation finished")
    ///     }
    ///
    static func animate(
        duration: TimeInterval,
        animations: () -> Void,
        completion: (() -> Void)? = nil
    ) {
        // We're not actually waiting for `duration` here – the point of the
        // drill is the closure ordering & syntax, not the real timing.
        animations()
        completion?()
    }

    /// Convenience helper to show trailing-closure syntax more clearly.
    static func animateWithTrailingClosureExample() {
        animate(duration: 0.25, animations: {
            print("🔵 Box is moving...")
        }) {
            print("✅ Box animation complete.")
        }

        // You could also imagine a version where `animations` is trailing:
        //
        //     animate(duration: 0.25) {
        //         print("🔵 Box is moving...")
        //     }
        //
        // by defining an overload with `animations` as the last parameter.
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call this from the playground to see the order of logs.
///
/// ```swift
/// demoAnimateBox()
/// ```
func demoAnimateBox() {
    print("Before animation call")

    BoxAnimator.animate(duration: 0.3, animations: {
        print("Animating box...")
    }) {
        print("Animation finished (completion closure)")
    }

    print("After animation call")
}
