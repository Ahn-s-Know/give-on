// Endpoints.swift
// Give On Farm — API 엔드포인트 상수

import Foundation

enum Endpoints {
    static let baseURL = ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "http://localhost:8000"
    static let apiPrefix = "/api/v1"

    // MARK: - Farms
    static func farms() -> String { "\(apiPrefix)/farms" }
    static func farm(_ id: Int) -> String { "\(apiPrefix)/farms/\(id)" }
    static func farmRisk(_ id: Int) -> String { "\(apiPrefix)/farms/\(id)/risk" }
    static func farmAlerts(_ id: Int) -> String { "\(apiPrefix)/farms/\(id)/alerts" }
    static func farmToken(_ id: Int) -> String { "\(apiPrefix)/farms/\(id)/token" }
    static func farmChecklist(_ id: Int) -> String { "\(apiPrefix)/farms/\(id)/checklist" }
    static func farmDamage(_ id: Int) -> String { "\(apiPrefix)/donations/damage-report" }

    // MARK: - Alerts
    static func alerts() -> String { "\(apiPrefix)/alerts" }

    // MARK: - Admin
    static func adminDashboard() -> String { "\(apiPrefix)/admin/dashboard" }
}
