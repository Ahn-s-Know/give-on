// HomeViewModel.swift
// Give On Farm — 홈 화면 ViewModel

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var riskLevel: RiskLevel = .safe
    @Published var currentTemp: Double = 0
    @Published var currentHumidity: Double = 0
    @Published var tomorrowMax: Double = 0
    @Published var latestAlertMessage: String? = nil
    @Published var checklistItems: [ChecklistItem] = []
    @Published var isLoading: Bool = false
    @Published var showDamageReport: Bool = false
    @Published var errorMessage: String? = nil

    private var farmId: Int? { UserDefaultsManager.shared.farmId }

    // MARK: - 데이터 로드

    func refresh() async {
        guard let farmId else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let risk = try await APIClient.shared.getFarmRisk(farmId: farmId)
            riskLevel = RiskLevel.from(risk.riskLevel)
            currentTemp = risk.currentWeather?.temperature ?? 0
            currentHumidity = risk.currentWeather?.humidity ?? 0
            latestAlertMessage = risk.alertMessage

            // 체크리스트 업데이트
            checklistItems = risk.checklist.enumerated().map { idx, text in
                ChecklistItem(id: idx, text: text)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - 체크리스트 토글

    func toggleChecklistItem(id: Int) {
        guard let idx = checklistItems.firstIndex(where: { $0.id == id }) else { return }
        checklistItems[idx].isCompleted.toggle()

        guard checklistItems[idx].isCompleted, let farmId else { return }
        let item = checklistItems[idx]

        Task {
            await APIClient.shared.saveChecklistItem(
                farmId: farmId,
                alertId: nil,
                itemId: item.id,
                itemText: item.text
            )
        }
    }
}

// MARK: - APIClient extension (non-throwing wrapper)

extension APIClient {
    func saveChecklistItem(farmId: Int, alertId: Int?, itemId: Int, itemText: String) async {
        try? await saveChecklistItem(farmId: farmId, alertId: alertId, itemId: itemId, itemText: itemText)
    }
}
