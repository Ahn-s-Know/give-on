// APIClient.swift
// Give On Farm — URLSession 기반 네트워크 클라이언트

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int, String)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL입니다."
        case .noData: return "데이터를 받지 못했습니다."
        case .decodingError(let e): return "데이터 파싱 오류: \(e.localizedDescription)"
        case .serverError(let code, let msg): return "서버 오류 (\(code)): \(msg)"
        case .networkError(let e): return "네트워크 오류: \(e.localizedDescription)"
        }
    }
}

final class APIClient: @unchecked Sendable {
    static let shared = APIClient()

    private let session: URLSession
    private let baseURL: String
    private let timeout: TimeInterval = 15

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
        self.baseURL = Endpoints.baseURL
    }

    // MARK: - Generic Request

    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: Encodable? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // FCM 토큰 / 농가 ID 헤더 (UserDefaults에서 로드)
        if let farmId = UserDefaultsManager.shared.farmId {
            request.setValue(String(farmId), forHTTPHeaderField: "X-Farm-ID")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                throw APIError.noData
            }

            if !(200..<300).contains(http.statusCode) {
                let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw APIError.serverError(http.statusCode, errorMsg)
            }

            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }

    // MARK: - Farm APIs

    func registerFarm(body: FarmCreateRequest) async throws -> FarmResponse {
        try await request(path: Endpoints.farms(), method: "POST", body: body, responseType: FarmResponse.self)
    }

    func getFarmRisk(farmId: Int) async throws -> RiskResponse {
        try await request(path: Endpoints.farmRisk(farmId), responseType: RiskResponse.self)
    }

    func getFarmAlerts(farmId: Int) async throws -> [AlertResponse] {
        try await request(path: Endpoints.farmAlerts(farmId), responseType: [AlertResponse].self)
    }

    func updateFCMToken(_ token: String) async throws {
        guard let farmId = UserDefaultsManager.shared.farmId else { return }
        struct TokenBody: Encodable { let token: String }
        _ = try? await request(
            path: Endpoints.farmToken(farmId),
            method: "POST",
            body: TokenBody(token: token),
            responseType: EmptyResponse.self
        )
    }

    func saveChecklistItem(farmId: Int, alertId: Int?, itemId: Int, itemText: String) async throws {
        struct Body: Encodable {
            let alertId: Int?
            let itemId: Int
            let itemText: String
            enum CodingKeys: String, CodingKey {
                case alertId = "alert_id"
                case itemId = "item_id"
                case itemText = "item_text"
            }
        }
        _ = try? await request(
            path: Endpoints.farmChecklist(farmId),
            method: "POST",
            body: Body(alertId: alertId, itemId: itemId, itemText: itemText),
            responseType: EmptyResponse.self
        )
    }

    func submitDamageReport(_ body: DamageReportCreate) async throws {
        _ = try? await request(
            path: Endpoints.farmDamage(0),
            method: "POST",
            body: body,
            responseType: EmptyResponse.self
        )
    }
}

// MARK: - Helpers

struct EmptyResponse: Decodable {}

struct FarmCreateRequest: Encodable {
    let name: String
    let ownerName: String
    let livestockType: String
    let livestockCount: Int
    let location: String
    let latitude: Double?
    let longitude: Double?
    let phoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case name, location, latitude, longitude
        case ownerName = "owner_name"
        case livestockType = "livestock_type"
        case livestockCount = "livestock_count"
        case phoneNumber = "phone_number"
    }
}
