//
//  InjectingMockService.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  InjectingMockService.swift
//
//  Analogy:
//  - Dependency injection is like putting batteries into a torch.
//    The torch (ViewModel) doesn’t *create* its own batteries,
//    it accepts any compatible ones from the outside:
//      – real batteries when you go camping (real service)
//      – rechargeable/test batteries at home (mock service).
//
//  - Depending on a protocol instead of a concrete type lets you swap
//    implementations easily for tests vs production.
//

import Foundation

// MARK: - Model

struct UserProfile: Equatable {
    let id: Int
    let name: String
    let bio: String
}

// MARK: - Service Protocol

protocol UserProfileService {
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void)
}

// MARK: - Real Implementation (could talk to network in a real app)

final class RealUserProfileService: UserProfileService {

    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        // For this drill we just simulate a successful fetch.
        // In a real app, this might use URLSession / networking.
        let profile = UserProfile(id: 1, name: "Joshua", bio: "iOS Developer")
        completion(.success(profile))
    }
}

// MARK: - ViewModel that depends on the protocol

final class ProfileViewModel {

    enum State: Equatable {
        case idle
        case loading
        case loaded(UserProfile)
        case error(String)
    }

    private let service: UserProfileService

    private(set) var state: State = .idle {
        didSet { onStateChange?(state) }
    }

    /// Called whenever `state` changes – useful for UI binding or tests.
    var onStateChange: ((State) -> Void)?

    init(service: UserProfileService) {
        self.service = service
    }

    func loadProfile() {
        state = .loading

        service.fetchProfile { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let profile):
                self.state = .loaded(profile)
            case .failure(let error):
                self.state = .error(error.localizedDescription)
            }
        }
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call from the playground:
///
/// ```swift
/// demoDependencyInjection()
/// ```
func demoDependencyInjection() {
    let realService = RealUserProfileService()
    let viewModel = ProfileViewModel(service: realService)

    viewModel.onStateChange = { state in
        print("State changed:", state)
    }

    viewModel.loadProfile()
}
