//
//  DecodeAPIResponse.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//
//
//  DecodeAPIResponse.swift
//
//  Analogy:
//  - A nested API response is like a big delivery box.
//    Inside it, you have:
///      - data: the actual items you ordered
///      - meta: the packing slip (page, total items, etc.)
//
//  Codable lets you describe BOTH the outer box and the inner items,
//  then JSONDecoder unpacks everything into your Swift types.
//

import Foundation

// MARK: - Reuse APIUser from TransformModels

// In TransformModels.swift we defined:
// struct APIUser {
//     let id: Int
//     let fullName: String
//     let roles: [String]
// }
// We haer now changed it to be decodable


// MARK: - Nested Response Models

struct APIResponseMeta: Decodable, Equatable {
    let page: Int
    let perPage: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
    }
}

struct APIUserListResponse: Decodable, Equatable {
    let data: [APIUser]
    let meta: APIResponseMeta
}

// MARK: - Decoder Helper

struct APIUserListDecoder {

    /// Decodes an APIUserListResponse from raw JSON data.
    static func decode(from data: Data) throws -> APIUserListResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(APIUserListResponse.self, from: data)
    }

    /// Convenience helper: returns just the users from the response.
    static func decodeUsers(from data: Data) throws -> [APIUser] {
        let response = try decode(from: data)
        return response.data
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call from the playground:
///
/// ```swift
/// demoDecodeAPIResponse()
/// ```
func demoDecodeAPIResponse() {
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

    guard let data = json.data(using: .utf8) else {
        print("Failed to create Data from JSON string")
        return
    }

    do {
        let response = try APIUserListDecoder.decode(from: data)
        print("Decoded \(response.data.count) users")
        print("Page:", response.meta.page, "of approx", (response.meta.total + response.meta.perPage - 1) / response.meta.perPage)
        if let first = response.data.first {
            print("First user:", first.fullName, "roles:", first.roles)
        }
    } catch {
        print("Failed to decode APIUserListResponse:", error)
    }
}
