// Models.swift
// Give On Farm — Codable 응답 모델

import Foundation

// MARK: - Farm

struct FarmResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let ownerName: String
    let livestockType: String
    let livestockCount: Int
    let location: String
    let latitude: Double?
    let longitude: Double?
    let phoneNumber: String?
    let subscription: String
    let isActive: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, location, latitude, longitude, subscription
        case ownerName = "owner_name"
        case livestockType = "livestock_type"
        case livestockCount = "livestock_count"
        case phoneNumber = "phone_number"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
}

// MARK: - Risk

struct RiskResponse: Codable {
    let farmId: Int
    let riskLevel: String
    let currentWeather: WeatherSummary?
    let alertMessage: String?
    let checklist: [String]

    enum CodingKeys: String, CodingKey {
        case farmId = "farm_id"
        case riskLevel = "risk_level"
        case currentWeather = "current_weather"
        case alertMessage = "alert_message"
        case checklist
    }
}

struct WeatherSummary: Codable {
    let temperature: Double
    let humidity: Double
    let measuredAt: String?

    enum CodingKeys: String, CodingKey {
        case temperature, humidity
        case measuredAt = "measured_at"
    }
}

// MARK: - Alert

struct AlertResponse: Codable, Identifiable {
    let id: Int
    let farmId: Int
    let riskLevel: String
    let temperature: Double?
    let humidity: Double?
    let message: String
    let isSent: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, temperature, humidity, message
        case farmId = "farm_id"
        case riskLevel = "risk_level"
        case isSent = "is_sent"
        case createdAt = "created_at"
    }
}

// MARK: - Checklist

struct ChecklistItem: Identifiable {
    let id: Int
    let text: String
    var isCompleted: Bool = false
}

// MARK: - Damage Report

struct DamageReportCreate: Codable {
    let farmId: Int
    let deadCount: Int
    let cause: String
    let estimatedLoss: Int?
    let farmerNote: String?

    enum CodingKeys: String, CodingKey {
        case cause
        case farmId = "farm_id"
        case deadCount = "dead_count"
        case estimatedLoss = "estimated_loss"
        case farmerNote = "farmer_note"
    }
}
