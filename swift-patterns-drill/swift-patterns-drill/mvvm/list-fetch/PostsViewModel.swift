//
//  PostsViewModel.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

//
//  PostsViewModel.swift
//
//  Analogy (MVVM):
//  - Model = the raw data (like ingredients).
//  - View = the plate the user eats from (UI layer).
//  - ViewModel = the chef in the kitchen:
//      * reads the raw ingredients (models / services)
//      * prepares them into a presentable form (view models)
//      * tells the waiter (view) when something changes.
//
//  The View doesn’t talk directly to the network or database.
//  It only listens to the ViewModel’s published state.
//

import Foundation
import Combine

// We already have NetworkPost in FetchPosts.swift:
// struct NetworkPost: Decodable, Equatable { id, title, body }

// MARK: - Repository Protocol

protocol PostsRepository {
    func fetchPosts() async throws -> [NetworkPost]
}

// MARK: - Simple Demo Repository (could wrap PostService in a real app)

struct DemoPostsRepository: PostsRepository {
    func fetchPosts() async throws -> [NetworkPost] {
        return [
            NetworkPost(id: 1, title: "Hello MVVM", body: "This is the first post."),
            NetworkPost(id: 2, title: "Another Post", body: "More body text goes here.")
        ]
    }
}

// MARK: - View-facing Row Model

struct PostRowViewModel: Equatable {
    let id: Int
    let title: String
    let bodyPreview: String
}

// MARK: - ViewModel

@MainActor
final class PostsViewModel: ObservableObject {
    
    enum State: Equatable {
        case idle
        case loading
        case loaded([PostRowViewModel])
        case error(String)
    }
    
    // The view will observe this in a real app
    @Published private(set) var state: State = .idle
    
    private let repository: PostsRepository
    
    init(repository: PostsRepository) {
        self.repository = repository
    }
    
    /// Loads posts from the repository, maps them to row view models,
    /// and updates the published state.
    func load() async {
        state = .loading
        
        do {
            let posts = try await repository.fetchPosts()
            let rows = posts.map { post in
                PostRowViewModel(
                    id: post.id,
                    title: post.title,
                    bodyPreview: String(post.body.prefix(50))
                )
            }
            state = .loaded(rows)
        } catch {
            state = .error("Failed to load posts")
        }
    }
    
    
    // MARK: - Demo (for Playground / breakpoints)
    
    /// Example of how a view/controller might use the ViewModel.
    ///
    /// ```swift
    /// demoPostsViewModel()
    /// ```
    func demoPostsViewModel() {
        let repository = DemoPostsRepository()
        let viewModel = PostsViewModel(repository: repository)
        
        // In SwiftUI you might call this from `.task { await viewModel.load() }`
        Task {
            await viewModel.load()
            
            switch viewModel.state {
            case .loaded(let rows):
                print("Loaded \(rows.count) posts:")
                rows.forEach { print("- \($0.title) | \($0.bodyPreview)") }
            case .error(let message):
                print("Error:", message)
            default:
                print("State:", viewModel.state)
            }
        }
    }
}
