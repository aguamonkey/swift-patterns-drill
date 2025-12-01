//
//  PureMathTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation
import XCTest
@testable import swift_patterns_drill

final class PureMathTests: XCTestCase {

    // MARK: - sum(_:)

    func testSumOfPositiveNumbers() {
        let result = PureMath.sum([1, 2, 3, 4])
        XCTAssertEqual(result, 10)
    }

    func testSumOfNegativeNumbers() {
        let result = PureMath.sum([-1, -2, -3])
        XCTAssertEqual(result, -6)
    }

    func testSumOfEmptyArrayIsZero() {
        let result = PureMath.sum([])
        XCTAssertEqual(result, 0)
    }

    // MARK: - average(_:)

    func testAverageOfNumbers() {
        let result = PureMath.average([1, 2, 3, 4])
        XCTAssertEqual(result, 2.5)
    }

    func testAverageOfSingleElement() {
        let result = PureMath.average([10])
        XCTAssertEqual(result, 10)
    }

    func testAverageOfEmptyArrayIsNil() {
        let result = PureMath.average([])
        XCTAssertNil(result)
    }

    // MARK: - max(_:) and min(_:)

    func testMaxReturnsLargestElement() {
        let result = PureMath.max([1, 9, 3, 4])
        XCTAssertEqual(result, 9)
    }

    func testMinReturnsSmallestElement() {
        let result = PureMath.min([1, 9, -2, 4])
        XCTAssertEqual(result, -2)
    }

    func testMaxOnEmptyArrayIsNil() {
        let result = PureMath.max([])
        XCTAssertNil(result)
    }

    func testMinOnEmptyArrayIsNil() {
        let result = PureMath.min([])
        XCTAssertNil(result)
    }
}
