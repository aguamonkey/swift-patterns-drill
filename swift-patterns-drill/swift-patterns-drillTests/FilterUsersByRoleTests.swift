//
//  FilterUsersByRoleTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

final class FilterUsersByRoleTests: XCTestCase {

    private func makeUsers() -> [User] {
        return [
            User(id: 1, name: "Alice", role: .admin),
            User(id: 2, name: "Bob", role: .editor),
            User(id: 3, name: "Charlie", role: .viewer),
            User(id: 4, name: "Dana", role: .admin)
        ]
    }

    func testAdminsFilterReturnsOnlyAdmins() {
        let users = makeUsers()

        let admins = UserFilter.admins(from: users)

        XCTAssertEqual(admins.count, 2)
        XCTAssertTrue(admins.allSatisfy { $0.role == .admin })
    }

    func testWithRoleReturnsOnlyMatchingRole() {
        let users = makeUsers()

        let editors = UserFilter.withRole(.editor, in: users)

        XCTAssertEqual(editors.count, 1)
        XCTAssertEqual(editors.first?.name, "Bob")
    }

    func testNonAdminsExcludesAdmins() {
        let users = makeUsers()

        let nonAdmins = UserFilter.nonAdmins(from: users)

        XCTAssertEqual(nonAdmins.count, 2)
        XCTAssertTrue(nonAdmins.allSatisfy { $0.role != .admin })
    }
}
