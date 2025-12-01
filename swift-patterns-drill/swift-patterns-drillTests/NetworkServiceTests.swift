//
//  NetworkServiceTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

// MARK: - Mock NetworkService for tests

private final class MockNetworkService: NetworkService {

    var lastURL: URL?
    var resultToReturn: Result<Data, Error>?

    func get(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        lastURL = url

        guard let resultToReturn else {
            fatalError("MockNetworkService.resultToReturn must be set before calling get(url:)")
        }

        // Simulate asynchronous behaviour
        DispatchQueue.global().async {
            completion(resultToReturn)
        }
    }
}

// MARK: - Tests

final class NetworkServiceTests: XCTestCase {

    func testStatusCheckerPassesURLThroughToNetworkService() {
        let mock = MockNetworkService()
        let checker = StatusChecker(network: mock)

        let expectedURL = URL(string: "https://example.com/status.txt")!
        let data = "OK".data(using: .utf8)!
        mock.resultToReturn = .success(data)

        let expectation = XCTestExpectation(description: "Completion called")

        checker.fetchStatusMessage(from: expectedURL) { result in
            switch result {
            case .success(let message):
                XCTAssertEqual(message, "OK")
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }

            XCTAssertEqual(mock.lastURL, expectedURL)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testStatusCheckerForwardsErrorFromNetworkService() {
        struct DummyError: Error, Equatable {}

        let mock = MockNetworkService()
        let checker = StatusChecker(network: mock)

        let url = URL(string: "https://example.com/status.txt")!
        mock.resultToReturn = .failure(DummyError())

        let expectation = XCTestExpectation(description: "Completion called")

        checker.fetchStatusMessage(from: url) { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to DummyError")
            case .failure(let error):
                XCTAssertTrue(error is DummyError, "Expected DummyError, got \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
