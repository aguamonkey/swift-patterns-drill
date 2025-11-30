//
//  DecodeAPIResponseTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation
import XCTest
@testable import swift_patterns_drill

final class DecodeAPIResponseTests: XCTestCase {

    private func makeValidJSONData() -> Data {
        let json = """
        {
          "data": [
            {
              "id": 1,
              "fullName": "Alice Admin",
              "roles": ["admin", "editor"]
            },
            {
              "id": 2,
              "fullName": "Bob Viewer",
              "roles": ["viewer"]
            }
          ],
          "meta": {
            "page": 1,
            "per_page": 20,
            "total": 2
          }
        }
        """
        return json.data(using: .utf8)!
    }

    func testDecodeFullResponseSucceeds() throws {
        let data = makeValidJSONData()

        let response = try APIUserListDecoder.decode(from: data)

        XCTAssertEqual(response.meta.page, 1)
        XCTAssertEqual(response.meta.perPage, 20)
        XCTAssertEqual(response.meta.total, 2)

        XCTAssertEqual(response.data.count, 2)
        XCTAssertEqual(response.data.first?.fullName, "Alice Admin")
        XCTAssertEqual(response.data.first?.roles, ["admin", "editor"])
    }

    func testDecodeUsersConvenienceReturnsUsersOnly() throws {
        let data = makeValidJSONData()

        let users = try APIUserListDecoder.decodeUsers(from: data)

        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users[1].fullName, "Bob Viewer")
        XCTAssertEqual(users[1].roles, ["viewer"])
    }

    func testDecodeFailsWhenDataFieldMissing() {
        let json = """
        {
          "meta": {
            "page": 1,
            "per_page": 20,
            "total": 0
          }
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try APIUserListDecoder.decode(from: json))
    }
}
