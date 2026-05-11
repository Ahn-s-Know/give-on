import SwiftUI

// MARK: - RiskLevel

enum RiskLevel: String, Comparable, CaseIterable {
    case safe = "safe"
    case caution = "caution"
    case danger = "danger"
    case emergency = "emergency"

    private var order: Int {
        switch self {
        case .safe:      return 0
        case .caution:   return 1
        case .danger:    return 2
        case .emergency: return 3
        }
    }

    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        lhs.order < rhs.order
    }

    var displayName: String {
        switch self {
        case .safe:      return "안전"
        case .caution:   return "주의"
        case .danger:    return "위험"
        case .emergency: return "긴급"
        }
    }

    var subtitle: String {
        switch self {
        case .safe:      return "현재 농장은 안전해요\n오늘도 좋은 하루 보내세요!"
        case .caution:   return "기상 상태에 주의가 필요해요\n농장 상태를 확인하세요."
        case .danger:    return "위험한 기상 상태입니다\n아래 체크리스트를 확인하세요."
        case .emergency: return "긴급 상황입니다!\n즉시 대응이 필요합니다."
        }
    }

    var systemIcon: String {
        switch self {
        case .safe:      return "checkmark.circle.fill"
        case .caution:   return "exclamationmark.circle.fill"
        case .danger:    return "exclamationmark.triangle.fill"
        case .emergency: return "xmark.octagon.fill"
        }
    }

    var signalColor: Color {
        switch self {
        case .safe:      return .gof.riskSafe
        case .caution:   return .gof.riskCaution
        case .danger:    return .gof.riskDanger
        case .emergency: return .gof.riskEmergency
        }
    }

    var lightColor: Color {
        signalColor.opacity(0.15)
    }
}

// MARK: - Models

struct WeatherInfo {
    let temperature: String
    let humidity: String
    let windSpeed: String
}

struct ChecklistItem: Identifiable {
    let id: Int
    let text: String
    var isCompleted: Bool = false
}

// MARK: - ViewModel

@MainActor
final class FarmStatusViewModel: ObservableObject, @unchecked Sendable {
    @Published var riskLevel: RiskLevel = .safe
    @Published var weather = WeatherInfo(temperature: "22", humidity: "58", windSpeed: "2")
    @Published var alertMessage: String? = nil
    @Published var checklistItems: [ChecklistItem] = []
    @Published var isLoading = false

    // TODO: 백엔드 연동 시 farm_id 주입
    private let farmId: String = UserDefaults.standard.string(forKey: "farm_id") ?? ""

    func fetchStatus() async {
        isLoading = true
        // TODO: APIClient.shared.get("/api/v1/farms/\(farmId)/risk")
        // 현재는 mock 데이터 사용
        isLoading = false
    }

    func toggleChecklist(id: Int) {
        guard let index = checklistItems.firstIndex(where: { $0.id == id }) else { return }
        checklistItems[index].isCompleted.toggle()
        // TODO: APIClient.shared.post("/api/v1/farms/\(farmId)/checklist", body: ...)
    }

    // MARK: - Preview / Debug Helpers

    func useMockSafe() {
        riskLevel = .safe
        alertMessage = nil
        checklistItems = []
        weather = WeatherInfo(temperature: "22", humidity: "58", windSpeed: "2")
    }

    func useMockCaution() {
        riskLevel = .caution
        alertMessage = "기온이 상승 중입니다. 환기 상태를 점검하세요."
        checklistItems = []
        weather = WeatherInfo(temperature: "28", humidity: "65", windSpeed: "1")
    }

    func useMockDanger() {
        riskLevel = .danger
        alertMessage = "현재 34.2°C로 닭 위험 수준입니다. 즉시 환풍기를 최대로 가동하고 음수 온도를 20°C 이하로 유지해 주세요."
        checklistItems = [
            ChecklistItem(id: 1, text: "환풍기 최대 가동 확인"),
            ChecklistItem(id: 2, text: "음수 온도 20°C 이하 유지"),
            ChecklistItem(id: 3, text: "차광막 설치 상태 점검"),
        ]
        weather = WeatherInfo(temperature: "34", humidity: "71", windSpeed: "1")
    }

    func useMockEmergency() {
        riskLevel = .emergency
        alertMessage = "폭염 특보 발령! 긴급 대응이 필요합니다. 지금 즉시 수의사에게 연락하고 가축을 그늘로 이동하세요."
        checklistItems = [
            ChecklistItem(id: 1, text: "수의사 긴급 연락"),
            ChecklistItem(id: 2, text: "가축 그늘 이동"),
            ChecklistItem(id: 3, text: "냉방 장비 최대 가동"),
            ChecklistItem(id: 4, text: "음수 공급 즉시 확인"),
        ]
        weather = WeatherInfo(temperature: "38", humidity: "80", windSpeed: "0")
    }
}
