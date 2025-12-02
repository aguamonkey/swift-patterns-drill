
//
//  TransformModels.swift
//
//  Analogy:
//  - map is like a production line where each raw item becomes a finished product.
//    One in → one out (same count).
//  - flatMap is like emptying several baskets of songs into ONE big playlist.
//    Many small arrays → one flattened array.
//
//  In a BBC-style task, map/flatMap often appear when transforming API models
//  into view models, or flattening nested arrays.
//

import Foundation

// MARK: - Models

/// Represents a user coming back from an API
//struct APIUser {
//    let id: Int
//    let fullName: String
//    let roles: [String]      // e.g. ["admin", "editor"]
//}

struct APIUser: Decodable, Equatable {
    let id: Int
    let fullName: String
    let roles: [String]      // e.g. ["admin", "editor"]
}


/// Represents a simplified model used by the UI
struct UserViewModel {
    let id: Int
    let displayName: String
    let isAdmin: Bool
}

// MARK: - Transform Functions

struct ModelTransformer {

    /// Uses `map` to convert API users into view models
    static func mapToViewModels(_ apiUsers: [APIUser]) -> [UserViewModel] {
        return apiUsers.map { apiUser in
            let admin = apiUser.roles.contains { $0.lowercased() == "admin" }
            return UserViewModel(
                id: apiUser.id,
                displayName: apiUser.fullName,
                isAdmin: admin
            )
        }
    }

    /// Uses `flatMap` to flatten all roles into a single list (may contain duplicates)
    static func allRoles(from apiUsers: [APIUser]) -> [String] {
        return apiUsers.flatMap { apiUser in
            apiUser.roles
        }
    }

    /// Uses `compactMap` (flatMap for optionals) to turn Strings into Ints, ignoring invalid ones
    static func parseIds(from strings: [String]) -> [Int] {
        return strings.compactMap { Int($0) }
    }
}

// MARK: - Demo (for Playground / breakpoints)

func demoTransformModels() {
    let users = [
        APIUser(id: 1, fullName: "Alice Admin", roles: ["admin", "editor"]),
        APIUser(id: 2, fullName: "Bob Viewer", roles: ["viewer"]),
        APIUser(id: 3, fullName: "Charlie Mixed", roles: ["editor", "viewer"])
    ]

    let viewModels = ModelTransformer.mapToViewModels(users)
    let roles = ModelTransformer.allRoles(from: users)
    let parsed = ModelTransformer.parseIds(from: ["1", "x", "2", "three", "3"])

    print("ViewModels (isAdmin flags):", viewModels.map { "\($0.displayName): \($0.isAdmin)" })
    print("All roles flattened:", roles)
    print("Parsed IDs:", parsed)
}

demoTransformModels()
