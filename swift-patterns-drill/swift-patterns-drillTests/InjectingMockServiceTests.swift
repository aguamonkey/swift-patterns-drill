//
//  InjectingMockServiceTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation
import XCTest
@testable import swift_patterns_drill

// MARK: - Mock Service

private final class MockUserProfileService: UserProfileService {

    var resultToReturn: Result<UserProfile, Error>?

    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let resultToReturn else {
            fatalError("MockUserProfileService.resultToReturn must be set before calling fetchProfile")
        }
        completion(resultToReturn)
    }
}

// MARK: - Tests

final class InjectingMockServiceTests: XCTestCase {

    func testViewModelGoesToLoadedStateOnSuccess() {
        // Arrange
        let mockService = MockUserProfileService()
        let expectedProfile = UserProfile(id: 42, name: "Alice", bio: "Test bio")
        mockService.resultToReturn = .success(expectedProfile)

        let viewModel = ProfileViewModel(service: mockService)

        // Capture all state changes
        var observedStates: [ProfileViewModel.State] = []
        viewModel.onStateChange = { state in
            observedStates.append(state)
        }

        // Act
        viewModel.loadProfile()

        // Assert
        XCTAssertEqual(observedStates.first, .loading)
        XCTAssertEqual(observedStates.last, .loaded(expectedProfile))
        XCTAssertEqual(viewModel.state, .loaded(expectedProfile))
    }

    func testViewModelGoesToErrorStateOnFailure() {
        struct DummyError: Error {}

        let mockService = MockUserProfileService()
        mockService.resultToReturn = .failure(DummyError())

        let viewModel = ProfileViewModel(service: mockService)

        var finalState: ProfileViewModel.State?
        viewModel.onStateChange = { state in
            finalState = state
        }

        viewModel.loadProfile()

        switch finalState {
        case .some(.error(let message)):
            XCTAssertFalse(message.isEmpty, "Expected an error message string")
        default:
            XCTFail("Expected error state, got \(String(describing: finalState))")
        }
    }
}
