//
//  CombineTapExample.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 01/12/2025.
//

//
//  CombineTapExample.swift
//
//  Analogy (Combine):
//  - Publisher  = tap            (where the water comes from)
//  - Operators  = attachments    (filters, pipes, gauges that transform flow)
//  - Subscriber = sink           (where the water ends up)
//  - AnyCancellable = valve      (you turn it to stop the flow)
//
//  In this drill we build a tiny pipeline:
//    tap (numbers) → filter (only even) → map (double them) → sink (collect)
//

import Foundation
import Combine

// MARK: - Pipeline Builder

struct CombineExamples {

    /// Builds a pipeline that:
    ///  - takes a stream of Ints
    ///  - keeps only even numbers
    ///  - doubles them
    ///
    /// tap (Publisher<Int>) -> filter -> map -> sink
    ///
    static func makeEvenNumberPipeline<P: Publisher>(
        from source: P
    ) -> AnyPublisher<Int, Never> where P.Output == Int, P.Failure == Never {
        return source
            .filter { value in
                value % 2 == 0       // only even numbers
            }
            .map { value in
                value * 2            // double them
            }
            .eraseToAnyPublisher()   // hide operator chain in AnyPublisher
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Example usage:
///
/// ```swift
/// demoCombineTapAnalogy()
/// ```
func demoCombineTapAnalogy() {
    // tap
    let source = PassthroughSubject<Int, Never>()

    // attachments (operators)
    let pipeline = CombineExamples.makeEvenNumberPipeline(from: source)

    // valve (keep a reference so the subscription stays alive)
    var cancellable: AnyCancellable? = pipeline
        .sink { value in
            print("Sink received:", value)
        }

    print("Sending values 1, 2, 3, 4")
    source.send(1)
    source.send(2)
    source.send(3)
    source.send(4)
    source.send(completion: .finished)

    // Turn the valve off
    cancellable?.cancel()
    cancellable = nil
}
