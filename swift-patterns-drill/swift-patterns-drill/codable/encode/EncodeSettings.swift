//
//  EncodeSettings.swift
//  swift-patterns-drill
//
//  Created by Joshua Browne on 30/11/2025.
//

//
//  EncodeSettings.swift
//
//  Analogy:
//  - Encoding is like filling out a form to send your preferences to a server.
//    Your Swift struct is your current app settings.
//    JSONEncoder is the clerk that copies those values into a JSON document
//    with the correct field names.
//
//  Decoding = reading someone else's form into your model.
//  Encoding = writing YOUR model out as JSON so others can read it.
//

import Foundation

// MARK: - Model

/// Represents basic app settings/preferences.
struct AppSettings: Codable, Equatable {
    let username: String
    let notificationsEnabled: Bool
    let preferredTheme: Theme
    let volume: Double

    enum Theme: String, Codable {
        case light
        case dark
        case system
    }

    enum CodingKeys: String, CodingKey {
        case username
        case notificationsEnabled = "notifications_enabled"
        case preferredTheme = "preferred_theme"
        case volume
    }
}

// MARK: - Encoder Helper

struct SettingsEncoder {

    /// Encodes AppSettings into JSON Data.
    static func encodeToJSONData(_ settings: AppSettings) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(settings)
    }

    /// Convenience: returns a JSON string, useful for logging / debugging.
    static func encodeToJSONString(_ settings: AppSettings) throws -> String {
        let data = try encodeToJSONData(settings)
        return String(data: data, encoding: .utf8) ?? ""
    }
}

// MARK: - Demo (for Playground / breakpoints)

/// Call this from the playground:
///
/// ```swift
/// demoEncodeSettings()
///
func demoEncodeSettings() {
    let settings = AppSettings(
        username: "joshua",
        notificationsEnabled: true,
        preferredTheme: .dark,
        volume: 0.8
    )

    do {
        let jsonString = try SettingsEncoder.encodeToJSONString(settings)
        print("Encoded JSON for AppSettings:\n\(jsonString)")
    } catch {
        print("Failed to encode AppSettings:", error)
    }
}
