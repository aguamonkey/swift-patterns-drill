//
//  EncodeSettingsTests.swift
//  swift-patterns-drillTests
//
//  Created by Joshua Browne on 30/11/2025.
//

import Foundation
import XCTest
@testable import swift_patterns_drill

final class EncodeSettingsTests: XCTestCase {

    func testEncodeSettingsProducesExpectedKeys() throws {
        let settings = AppSettings(
            username: "joshua",
            notificationsEnabled: true,
            preferredTheme: .dark,
            volume: 0.8
        )

        let data = try SettingsEncoder.encodeToJSONData(settings)

        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = jsonObject as? [String: Any] else {
            return XCTFail("Expected JSON dictionary")
        }

        XCTAssertEqual(dict["username"] as? String, "joshua")
        XCTAssertEqual(dict["notifications_enabled"] as? Bool, true)
        XCTAssertEqual(dict["preferred_theme"] as? String, "dark")

        if let volume = dict["volume"] as? Double {
            XCTAssertEqual(volume, 0.8, accuracy: 0.0001)
        } else {
            XCTFail("Expected Double for key 'volume'")
        }
    }


    func testRoundTripEncodeDecode() throws {
        let original = AppSettings(
            username: "alice",
            notificationsEnabled: false,
            preferredTheme: .system,
            volume: 0.5
        )

        let data = try SettingsEncoder.encodeToJSONData(original)

        // Use the Codable conformance to decode back.
        let decoded = try JSONDecoder().decode(AppSettings.self, from: data)

        XCTAssertEqual(decoded, original)
    }
}
