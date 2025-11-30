//
//  DecodeUser.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  DecodeUser.swift
//
//  Analogy:
//  - Codable is like passport control at an airport.
//    The JSON is a traveller arriving with documents.
//    Your Swift type (struct) is the “expected form”.
//    JSONDecoder is the officer that checks:
//      - Do all required fields exist?
//      - Are they in the right format?
//
//  If the JSON doesn’t match your struct, decoding fails “at the gate”
//  instead of causing random crashes later.
//

import Foundation

// MARK: - Model

/// A simple user model that we expect from JSON.
struct SimpleUser: Decodable, Equatable {
    let id: Int
    let name: String
    let email: String
    let isAdmin: Bool
}

// MARK: - Decoder Helper

struct SimpleUserDecoder {

    /// Decodes a single `SimpleUser` from JSON data.
    static func decodeSingle(from data: Data) throws -> SimpleUser {
        let decoder = JSONDecoder()
        return try decoder.decode(SimpleUser.self, from: data)
    }

    /// Decodes an array of `SimpleUser` from JSON data.
    static func decodeArray(from data: Data) throws -> [SimpleUser] {
        let decoder = JSONDecoder()
        return try decoder.decode([SimpleUser].self, from: data)
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage you can call from the playground:
///
/// ```swift
/// demoDecodeUser()
/// ```
func demoDecodeUser() {
    let json = """
    {
      "id": 1,
      "name": "Alice",
      "email": "alice@example.com",
      "isAdmin": true
    }
    """

    guard let data = json.data(using: .utf8) else {
        print("Failed to create Data from JSON string")
        return
    }

    do {
        let user = try SimpleUserDecoder.decodeSingle(from: data)
        print("Decoded user:", user.name, "- isAdmin:", user.isAdmin)
    } catch {
        print("Failed to decode SimpleUser:", error)
    }

    // Array example
    let arrayJSON = """
    [
      { "id": 1, "name": "Alice", "email": "alice@example.com", "isAdmin": true },
      { "id": 2, "name": "Bob", "email": "bob@example.com", "isAdmin": false }
    ]
    """

    if let arrayData = arrayJSON.data(using: .utf8) {
        do {
            let users = try SimpleUserDecoder.decodeArray(from: arrayData)
            print("Decoded \(users.count) users")
        } catch {
            print("Failed to decode [SimpleUser]:", error)
        }
    }
}
