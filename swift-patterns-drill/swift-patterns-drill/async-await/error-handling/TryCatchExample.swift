//
//  TryCatchExample.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  TryCatchExample.swift
//
//  Analogy:
//  - throw is like stamping a parcel “PROBLEM – RETURN TO SENDER”.
//  - try is you *attempting* to open the parcel, knowing it might come back.
//  - do { ... } catch { ... } is the safe unpacking area:
//      you try to open it, and if something goes wrong, you handle it cleanly.
//
//  In real projects, this is how you protect your app from crashing when
//  something (network, parsing, maths, file IO) fails.
//

import Foundation

// MARK: - Error Type

enum MathError: Error, Equatable {
    case divisionByZero
    case negativeSquareRoot
}

// MARK: - Safe Math Functions

struct SafeMath {

    /// Divides `a` by `b`, throwing if `b == 0`.
    static func divide(_ a: Double, by b: Double) throws -> Double {
        guard b != 0 else {
            throw MathError.divisionByZero
        }
        return a / b
    }

    /// Returns the square root of a non-negative value, or throws.
    static func squareRoot(_ value: Double) throws -> Double {
        guard value >= 0 else {
            throw MathError.negativeSquareRoot
        }
        return sqrt(value)
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage you can call from the playground:
///
/// ```swift
/// demoTryCatch()
/// ```
func demoTryCatch() {
    do {
        let result = try SafeMath.divide(10, by: 2)
        print("10 / 2 =", result)

        let root = try SafeMath.squareRoot(9)
        print("sqrt(9) =", root)

        // This line will throw
        _ = try SafeMath.divide(1, by: 0)
        print("This will not be printed")

    } catch MathError.divisionByZero {
        print("❗ Cannot divide by zero – show a friendly error to the user.")
    } catch MathError.negativeSquareRoot {
        print("❗ Cannot take the square root of a negative number.")
    } catch {
        print("❗ An unexpected error occurred:", error)
    }
}
