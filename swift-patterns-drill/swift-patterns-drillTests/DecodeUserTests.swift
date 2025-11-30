//
//  DecodeUserTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

final class DecodeUserTests: XCTestCase {

    func testDecodeSingleUserSucceeds() throws {
        let json = """
        {
          "id": 1,
          "name": "Alice",
          "email": "alice@example.com",
          "isAdmin": true
        }
        """.data(using: .utf8)!

        let user = try SimpleUserDecoder.decodeSingle(from: json)

        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Alice")
        XCTAssertEqual(user.email, "alice@example.com")
        XCTAssertTrue(user.isAdmin)
    }

    func testDecodeArrayOfUsersSucceeds() throws {
        let json = """
        [
          { "id": 1, "name": "Alice", "email": "alice@example.com", "isAdmin": true },
          { "id": 2, "name": "Bob", "email": "bob@example.com", "isAdmin": false }
        ]
        """.data(using: .utf8)!

        let users = try SimpleUserDecoder.decodeArray(from: json)

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[0].name, "Alice")
        XCTAssertEqual(users[1].name, "Bob")
    }

    func testDecodeFailsWhenFieldMissing() {
        // Missing "isAdmin" field
        let json = """
        {
          "id": 1,
          "name": "Alice",
          "email": "alice@example.com"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try SimpleUserDecoder.decodeSingle(from: json))
    }
}
