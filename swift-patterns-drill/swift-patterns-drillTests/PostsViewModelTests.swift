//
//  PostsViewModelTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

// MARK: - Mock Repository

private final class MockPostsRepository: PostsRepository {

    var resultToReturn: Result<[NetworkPost], Error>?

    func fetchPosts() async throws -> [NetworkPost] {
        guard let resultToReturn else {
            fatalError("MockPostsRepository.resultToReturn must be set before calling fetchPosts()")
        }

        switch resultToReturn {
        case .success(let posts):
            return posts
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - Tests

@MainActor
final class PostsViewModelTests: XCTestCase {

    func testLoadSetsLoadedStateOnSuccess() async {
        // Arrange
        let mockRepo = MockPostsRepository()
        let posts = [
            NetworkPost(id: 1, title: "First", body: "First body"),
            NetworkPost(id: 2, title: "Second", body: "Second body is a bit longer")
        ]
        mockRepo.resultToReturn = .success(posts)

        let viewModel = PostsViewModel(repository: mockRepo)

        // Act
        await viewModel.load()

        // Assert
        guard case .loaded(let rows) = viewModel.state else {
            return XCTFail("Expected loaded state, got \(viewModel.state)")
        }

        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(rows[0].title, "First")
        XCTAssertEqual(rows[1].title, "Second")
        XCTAssertEqual(rows[0].bodyPreview, "First body")
    }

    func testLoadSetsErrorStateOnFailure() async {
        struct DummyError: Error {}

        let mockRepo = MockPostsRepository()
        mockRepo.resultToReturn = .failure(DummyError())

        let viewModel = PostsViewModel(repository: mockRepo)

        await viewModel.load()

        guard case .error(let message) = viewModel.state else {
            return XCTFail("Expected error state, got \(viewModel.state)")
        }

        XCTAssertFalse(message.isEmpty)
    }

    func testInitialStateIsIdle() {
        let mockRepo = MockPostsRepository()
        mockRepo.resultToReturn = .success([])

        let viewModel = PostsViewModel(repository: mockRepo)

        XCTAssertEqual(viewModel.state, .idle)
    }
}
