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

demoSorting()
