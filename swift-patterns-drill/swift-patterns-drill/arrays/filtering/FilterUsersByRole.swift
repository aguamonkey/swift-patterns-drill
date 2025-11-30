//
//  FilterUsersByRole.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

//
//  FilterUsersByRole.swift
//
//  Analogy: Filtering is like choosing which players to put on the pitch.
//  The array is your full squad. The filter closure is the selection rule
//  (only defenders, only strikers, everyone except the injured).
//

import Foundation

// MARK: - Model

enum UserRole {
    case admin
    case editor
    case viewer
}

struct User {
    let id: Int
    let name: String
    let role: UserRole
}

// MARK: - Filtering Functions

struct UserFilter {

    /// Returns only users with the `.admin` role
    static func admins(from users: [User]) -> [User] {
        return users.filter { user in
            user.role == .admin
        }
    }

    /// Returns only users that match the given role
    static func withRole(_ role: UserRole, in users: [User]) -> [User] {
        return users.filter { user in
            user.role == role
        }
    }

    /// Returns all users that are *not* admins
    static func nonAdmins(from users: [User]) -> [User] {
        return users.filter { user in
            user.role != .admin
        }
    }
}

// MARK: - Demo (for Playground / breakpoints)

func demoFilteringUsers() {
    let users: [User] = [
        User(id: 1, name: "Alice", role: .admin),
        User(id: 2, name: "Bob", role: .editor),
        User(id: 3, name: "Charlie", role: .viewer),
        User(id: 4, name: "Dana", role: .admin)
    ]

    let onlyAdmins = UserFilter.admins(from: users)
    let onlyEditors = UserFilter.withRole(.editor, in: users)
    let notAdmins = UserFilter.nonAdmins(from: users)

    print("Admins:", onlyAdmins.map { $0.name })
    print("Editors:", onlyEditors.map { $0.name })
    print("Non-admins:", notAdmins.map { $0.name })
}
