//
//  CombineTapExampleTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 01/12/2025.
//

import Foundation
import XCTest
import Combine
@testable import swift_patterns_drill

final class CombineTapExampleTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testEvenNumberPipelineFiltersAndDoubles() {
        // tap
        let source = PassthroughSubject<Int, Never>()

        // build pipeline
        let pipeline = CombineExamples.makeEvenNumberPipeline(from: source)

        var received: [Int] = []

        // sink
        pipeline
            .sink { value in
                received.append(value)
            }
            .store(in: &cancellables)

        // Send some values down the pipe
        source.send(1)
        source.send(2)
        source.send(3)
        source.send(4)
        source.send(completion: .finished)

        // Only even numbers should be doubled:
        // 2 -> 4, 4 -> 8
        XCTAssertEqual(received, [4, 8])
    }

    func testPipelineEmitsNothingForNoEvenNumbers() {
        let source = PassthroughSubject<Int, Never>()
        let pipeline = CombineExamples.makeEvenNumberPipeline(from: source)

        var received: [Int] = []

        pipeline
            .sink { value in
                received.append(value)
            }
            .store(in: &cancellables)

        source.send(1)
        source.send(3)
        source.send(5)
        source.send(completion: .finished)

        XCTAssertTrue(received.isEmpty)
    }
}
