//
//  FetchDataWithCompletion.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  FetchDataWithCompletion.swift
//
//  Analogy:
//  - A completion handler is like leaving your phone number with a restaurant.
//    You place an order (start the request) and give them a number (the closure).
//    When the food is ready, they call you back with the result.
//
//  async/await = sit down and wait for the result in place.
//  completion handler = give a callback so they can respond later.
//
//  BBC-style usage: older APIs, URLSession dataTask, CoreLocation, etc.
//

import Foundation

// MARK: - Reuse NetworkPost from async example
// We assume `NetworkPost` already exists (from FetchPosts.swift).
// If not, you can move it into a shared file, or uncomment this:
//
// struct NetworkPost: Decodable, Equatable {
//     let id: Int
//     let title: String
//     let body: String
// }

// MARK: - Error Type

enum CompletionPostServiceError: Error, Equatable {
    case invalidStatusCode(Int)
    case decodingFailed
}

// MARK: - HTTP Client Abstraction (Completion-style)

protocol CompletionHTTPClient {
    func data(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void)
}

/// Concrete implementation backed by URLSession
final class URLSessionCompletionHTTPClient: CompletionHTTPClient {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func data(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data, let response else {
                // In a real app you might define a dedicated "noData" error.
                completion(.failure(CompletionPostServiceError.decodingFailed))
                return
            }

            completion(.success((data, response)))
        }

        task.resume()
    }
}

// MARK: - Service

struct CompletionPostService {

    private let client: CompletionHTTPClient

    init(client: CompletionHTTPClient) {
        self.client = client
    }

    /// Fetches posts using a completion handler-based API.
    func fetchPosts(
        from url: URL,
        completion: @escaping (Result<[NetworkPost], Error>) -> Void
    ) {
        client.data(from: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    completion(.failure(CompletionPostServiceError.invalidStatusCode(statusCode)))
                    return
                }

                do {
                    let posts = try JSONDecoder().decode([NetworkPost].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(CompletionPostServiceError.decodingFailed))
                }
            }
        }
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage you can call from the playground:
///
/// ```swift
/// demoFetchPostsWithCompletion()
/// ```
func demoFetchPostsWithCompletion() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
        print("Invalid URL")
        return
    }

    let client = URLSessionCompletionHTTPClient()
    let service = CompletionPostService(client: client)

    service.fetchPosts(from: url) { result in
        switch result {
        case .success(let posts):
            print("Fetched \(posts.count) posts (completion-handler)")
            if let first = posts.first {
                print("First post title:", first.title)
            }
        case .failure(let error):
            print("Failed to fetch posts (completion-handler):", error)
        }
    }
}
