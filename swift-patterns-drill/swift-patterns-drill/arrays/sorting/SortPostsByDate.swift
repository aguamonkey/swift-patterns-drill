//
//  SortPostsByDate.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  SortPostsByDate.swift
//
//  Analogy: Sorting is like arranging songs in StudyBeats by release date.
//  The array is your playlist. The sort closure is the rule you choose
//  (newest first, oldest first).
//

import Foundation

// MARK: - Model
struct Post {
    let id: Int
    let title: String
    let createdAt: Date
}

// MARK: - Sorting Functions
struct PostSorter {

    /// Sorts posts from newest → oldest
    static func sortNewestFirst(_ posts: [Post]) -> [Post] {
        return posts.sorted { a, b in
            a.createdAt > b.createdAt
        }
    }

    /// Sorts posts from oldest → newest
    static func sortOldestFirst(_ posts: [Post]) -> [Post] {
        return posts.sorted { a, b in
            a.createdAt < b.createdAt
        }
    }
}

// MARK: - Demo (you can run this in a Playground or breakpoints)
func demoSorting() {
    let now = Date()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
    let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: now)!

    let posts = [
        Post(id: 1, title: "Old Post", createdAt: lastWeek),
        Post(id: 2, title: "Yesterday's Post", createdAt: yesterday),
        Post(id: 3, title: "New Post", createdAt: now)
    ]

    let newest = PostSorter.sortNewestFirst(posts)
    let oldest = PostSorter.sortOldestFirst(posts)

    print("Newest first:", newest.map { $0.title })
    print("Oldest first:", oldest.map { $0.title })
}

//
// BBC Variation:
// Given an array of Post where createdAt can be nil,
// sort so that nil dates appear at the bottom.
//
extension PostSorter {
    static func sortWithNilAtBottom(_ posts: [Post?]) -> [Post?] {
        return posts.sorted { a, b in
            switch (a?.createdAt, b?.createdAt) {
            case let (d1?, d2?):
                return d1 > d2      // both have dates → compare normally
            case (nil, _?):
                return false        // nil goes after real dates
            case (_?, nil):
                return true         // real dates go first
            case (nil, nil):
                return false        // stable
            }
        }
    }
}
