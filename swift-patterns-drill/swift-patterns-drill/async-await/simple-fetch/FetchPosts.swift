//
//  FetchPosts.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  FetchPosts.swift
//
//  Analogy:
//  - async/await is like ordering food at a restaurant.
//    You place the order (start the request), then relax or do other things,
//    and the waiter brings the result back later (the awaited response).
//
//  - The service is the kitchen: it knows how to turn an order (URL)
//    into a finished dish (decoded models).
//

import Foundation

// MARK: - Models

/// Simple post model from a JSON API
struct NetworkPost: Decodable, Equatable {
    let id: Int
    let title: String
    let body: String
}

// MARK: - HTTP Client Abstraction

protocol HTTPClient {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await self.data(from: url, delegate: nil)
    }
}

// MARK: - Service

enum PostServiceError: Error {
    case invalidStatusCode(Int)
    case decodingFailed
}

struct PostService {

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    /// Fetches posts from the given URL using async/await.
    /// - Throws: `URLError`, `PostServiceError.invalidStatusCode`, or `PostServiceError.decodingFailed`.
    func fetchPosts(from url: URL) async throws -> [NetworkPost] {
        let (data, response) = try await client.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw PostServiceError.invalidStatusCode(statusCode)
        }

        do {
            return try JSONDecoder().decode([NetworkPost].self, from: data)
        } catch {
            throw PostServiceError.decodingFailed
        }
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage you can call from the playground:
///
/// ```swift
/// demoFetchPosts()
/// ```
func demoFetchPosts() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        print("Invalid URL")
        return
    }

    let service = PostService(client: URLSession.shared)

    Task {
        do {
            let posts = try await service.fetchPosts(from: url)
            print("Fetched \(posts.count) posts")
            if let first = posts.first {
                print("First post title:", first.title)
            }
        } catch {
            print("Failed to fetch posts:", error)
        }
    }
}
