//
//  FetchPostsTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

// MARK: - Mock HTTP Client

private final class MockHTTPClient: HTTPClient {

    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToThrow: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = errorToThrow {
            throw error
        }

        guard let data = dataToReturn, let response = responseToReturn else {
            fatalError("MockHTTPClient not configured correctly")
        }

        return (data, response)
    }
}

// MARK: - Tests

final class FetchPostsTests: XCTestCase {

    func testFetchPostsDecodesValidJSON() async throws {
        // Arrange
        let mockClient = MockHTTPClient()

        let json = """
        [
          { "id": 1, "title": "Hello", "body": "World" },
          { "id": 2, "title": "Another", "body": "Post" }
        ]
        """.data(using: .utf8)!

        let url = URL(string: "https://example.com/posts")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        mockClient.dataToReturn = json
        mockClient.responseToReturn = response

        let service = PostService(client: mockClient)

        // Act
        let posts = try await service.fetchPosts(from: url)

        // Assert
        XCTAssertEqual(posts.count, 2)
        XCTAssertEqual(posts.first?.title, "Hello")
        XCTAssertEqual(posts.first?.body, "World")
    }

    func testFetchPostsThrowsOnInvalidStatusCode() async {
        // Arrange
        let mockClient = MockHTTPClient()

        let json = "[]".data(using: .utf8)!
        let url = URL(string: "https://example.com/posts")!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        mockClient.dataToReturn = json
        mockClient.responseToReturn = response

        let service = PostService(client: mockClient)

        // Act & Assert
        do {
            _ = try await service.fetchPosts(from: url)
            XCTFail("Expected PostServiceError.invalidStatusCode to be thrown")
        } catch let error as PostServiceError {
            switch error {
            case .invalidStatusCode(let code):
                XCTAssertEqual(code, 500)
            default:
                XCTFail("Expected invalidStatusCode, got \(error)")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testFetchPostsPropagatesUnderlyingNetworkError() async {
        // Arrange
        let mockClient = MockHTTPClient()

        struct DummyError: Error {}
        mockClient.errorToThrow = DummyError()

        let url = URL(string: "https://example.com/posts")!
        let service = PostService(client: mockClient)

        // Act & Assert
        do {
            _ = try await service.fetchPosts(from: url)
            XCTFail("Expected DummyError to be thrown")
        } catch is DummyError {
            // success
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
