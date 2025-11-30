//
//  FetchDataWithCompletionTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

// MARK: - Mock Client

private final class MockCompletionHTTPClient: CompletionHTTPClient {

    var resultToReturn: Result<(Data, URLResponse), Error>?

    func data(from url: URL, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        guard let resultToReturn else {
            fatalError("MockCompletionHTTPClient.resultToReturn not set")
        }
        // Simulate async callback
        DispatchQueue.global().async {
            completion(resultToReturn)
        }
    }
}

// MARK: - Tests

final class FetchDataWithCompletionTests: XCTestCase {

    private func makeValidResponse(url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    func testFetchPostsSuccessDecodesJSON() {
        let mockClient = MockCompletionHTTPClient()
        let url = URL(string: "https://example.com/posts")!

        let json = """
        [
          { "id": 1, "title": "Hello", "body": "World" },
          { "id": 2, "title": "Another", "body": "Post" }
        ]
        """.data(using: .utf8)!

        mockClient.resultToReturn = .success((json, makeValidResponse(url: url)))

        let service = CompletionPostService(client: mockClient)

        let expectation = XCTestExpectation(description: "Completion called")

        service.fetchPosts(from: url) { result in
            switch result {
            case .success(let posts):
                XCTAssertEqual(posts.count, 2)
                XCTAssertEqual(posts.first?.title, "Hello")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPostsFailureOnInvalidStatusCode() {
        let mockClient = MockCompletionHTTPClient()
        let url = URL(string: "https://example.com/posts")!

        let json = "[]".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        mockClient.resultToReturn = .success((json, response))

        let service = CompletionPostService(client: mockClient)

        let expectation = XCTestExpectation(description: "Completion called")

        service.fetchPosts(from: url) { result in
            switch result {
            case .success:
                XCTFail("Expected failure for invalid status code")
            case .failure(let error):
                guard let serviceError = error as? CompletionPostServiceError else {
                    return XCTFail("Expected CompletionPostServiceError, got \(error)")
                }
                switch serviceError {
                case .invalidStatusCode(let code):
                    XCTAssertEqual(code, 500)
                default:
                    XCTFail("Expected invalidStatusCode, got \(serviceError)")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchPostsPropagatesUnderlyingError() {
        struct DummyError: Error, Equatable {}

        let mockClient = MockCompletionHTTPClient()
        mockClient.resultToReturn = .failure(DummyError())

        let url = URL(string: "https://example.com/posts")!
        let service = CompletionPostService(client: mockClient)

        let expectation = XCTestExpectation(description: "Completion called")

        service.fetchPosts(from: url) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to underlying error")
            case .failure(let error):
                XCTAssertTrue(error is DummyError, "Expected DummyError, got \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
