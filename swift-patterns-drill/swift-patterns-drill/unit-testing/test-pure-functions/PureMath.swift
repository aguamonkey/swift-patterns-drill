//
//  PureMath.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 01/12/2025.
//

//
//  PureMath.swift
//
//  Analogy:
//  - A pure function is like a calculator:
//      * Same inputs → same output.
//      * No hidden state, no side effects, no network, no disk.
//  - This makes pure functions *perfect* for unit tests, because you can
//    reason about them in isolation.
//
//  In production code: formatting helpers, small math utilities, mapping,
//  filtering logic, etc. are all great candidates for pure functions.
//

import Foundation

struct PureMath {

    /// Returns the sum of all numbers in the array.
    /// For an empty array, returns 0.
    static func sum(_ numbers: [Int]) -> Int {
        return numbers.reduce(0, +)
    }

    /// Returns the average of the numbers as a Double.
    /// For an empty array, returns nil.
    static func average(_ numbers: [Int]) -> Double? {
        guard !numbers.isEmpty else { return nil }
        let total = Double(sum(numbers))
        return total / Double(numbers.count)
    }

    /// Returns the maximum value in the array, or nil if the array is empty.
    static func max(_ numbers: [Int]) -> Int? {
        return numbers.max()
    }

    /// Returns the minimum value in the array, or nil if the array is empty.
    static func min(_ numbers: [Int]) -> Int? {
        return numbers.min()
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call from the playground:
///
/// ```swift
/// demoPureMath()
/// ```
func demoPureMath() {
    let numbers = [1, 2, 3, 4, 5]

    let total = PureMath.sum(numbers)
    let avg = PureMath.average(numbers)
    let maxValue = PureMath.max(numbers)
    let minValue = PureMath.min(numbers)

    print("Numbers:", numbers)
    print("Sum:", total)
    print("Average:", avg ?? .nan)
    print("Max:", maxValue ?? .min)
    print("Min:", minValue ?? .max)
}
