//
//  TransformModelsTests.swift.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

final class TransformModelsTests: XCTestCase {

    private func makeAPIUsers() -> [APIUser] {
        return [
            APIUser(id: 1, fullName: "Alice Admin", roles: ["admin", "editor"]),
            APIUser(id: 2, fullName: "Bob Viewer", roles: ["viewer"]),
            APIUser(id: 3, fullName: "Charlie Mixed", roles: ["editor", "viewer"])
        ]
    }

    func testMapToViewModelsMarksAdminsCorrectly() {
        let apiUsers = makeAPIUsers()

        let viewModels = ModelTransformer.mapToViewModels(apiUsers)

        XCTAssertEqual(viewModels.count, 3)
        XCTAssertTrue(viewModels.first(where: { $0.displayName == "Alice Admin" })?.isAdmin ?? false)
        XCTAssertFalse(viewModels.first(where: { $0.displayName == "Bob Viewer" })?.isAdmin ?? true)
    }

    func testAllRolesFlattensRolesFromAllUsers() {
        let apiUsers = makeAPIUsers()

        let roles = ModelTransformer.allRoles(from: apiUsers)

        XCTAssertEqual(roles.count, 5) // ["admin", "editor", "viewer", "editor", "viewer"]
        XCTAssertTrue(roles.contains("admin"))
        XCTAssertTrue(roles.contains("viewer"))
    }

    func testParseIdsUsesCompactMapToIgnoreInvalidValues() {
        let input = ["1", "x", "2", "three", "3"]

        let ids = ModelTransformer.parseIds(from: input)

        XCTAssertEqual(ids, [1, 2, 3])
    }
}
