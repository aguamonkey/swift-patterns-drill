//
//  SortArrayTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation

import XCTest
@testable import swift_patterns_drill

final class SortPostsTests: XCTestCase {

    func testSortNewestFirst() {
        let now = Date()
        let earlier = now.addingTimeInterval(-100)

        let posts = [
            Post(id: 1, title: "Earlier", createdAt: earlier),
            Post(id: 2, title: "Now", createdAt: now)
        ]

        let sorted = PostSorter.sortNewestFirst(posts)

        XCTAssertEqual(sorted.first?.title, "Now")
    }
}
