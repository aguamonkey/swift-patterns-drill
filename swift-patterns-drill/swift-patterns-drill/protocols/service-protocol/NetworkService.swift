//
//  NetworkService.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  NetworkService.swift
//
//  Analogy:
//  - A protocol is like a job description.
//    It says *what* the worker must be able to do, not *how* they do it.
//  - The concrete type (e.g. URLSessionNetworkService) is the actual employee.
//  - Because the app depends on the job description (protocol) instead of a
//    specific employee, we can swap people in/out easily: real service in
//    production, mock service in tests.
//
//  Here, NetworkService describes “something that can GET data from a URL”.
//  StatusChecker depends only on that protocol, so we can inject either a real
//  or fake implementation.
//

import Foundation

// MARK: - Protocol

protocol NetworkService {
    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - Concrete implementation using URLSession

final class URLSessionNetworkService: NetworkService {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                let noDataError = NSError(
                    domain: "NetworkService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No data returned"]
                )
                completion(.failure(noDataError))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}

// MARK: - Consumer depending on the protocol, not the concrete type

struct StatusChecker {

    let network: NetworkService

    /// Fetches a status message as a String from the given URL.
    /// In a real app, you might decode JSON here instead.
    func fetchStatusMessage(
        from url: URL,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        network.get(url: url) { result in
            switch result {
            case .success(let data):
                let message = String(data: data, encoding: .utf8) ?? ""
                completion(.success(message))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage (will actually hit the network if you use a real URL).
///
/// ```swift
/// demoNetworkService()
/// ```
func demoNetworkService() {
    guard let url = URL(string: "https://example.com/status.txt") else {
        print("Invalid URL")
        return
    }

    let service = URLSessionNetworkService()
    let checker = StatusChecker(network: service)

    checker.fetchStatusMessage(from: url) { result in
        switch result {
        case .success(let message):
            print("Status message:", message)
        case .failure(let error):
            print("Failed to fetch status:", error)
        }
    }
}
