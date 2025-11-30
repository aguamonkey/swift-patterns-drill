//
//  TryCatchExampleTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation
import XCTest
@testable import swift_patterns_drill

final class TryCatchExampleTests: XCTestCase {

    func testDivideSucceedsForNonZeroDenominator() throws {
        let result = try SafeMath.divide(10, by: 2)
        XCTAssertEqual(result, 5)
    }

    func testDivideThrowsOnZeroDenominator() {
        XCTAssertThrowsError(try SafeMath.divide(1, by: 0)) { error in
            guard let mathError = error as? MathError else {
                return XCTFail("Expected MathError, got \(error)")
            }
            XCTAssertEqual(mathError, .divisionByZero)
        }
    }

    func testSquareRootSucceedsForPositiveValue() throws {
        let result = try SafeMath.squareRoot(9)
        XCTAssertEqual(result, 3)
    }

    func testSquareRootThrowsOnNegativeValue() {
        XCTAssertThrowsError(try SafeMath.squareRoot(-1)) { error in
            guard let mathError = error as? MathError else {
                return XCTFail("Expected MathError, got \(error)")
            }
            XCTAssertEqual(mathError, .negativeSquareRoot)
        }
    }
}
