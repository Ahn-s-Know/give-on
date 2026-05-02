// HomeView.swift
// Give On Farm — 메인 위험도 홈 화면

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── 위험도 신호등 ──
                    RiskSignalView(level: viewModel.riskLevel)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                    // ── 현재 기상 요약 ──
                    WeatherSummaryCard(
                        temperature: viewModel.currentTemp,
                        humidity: viewModel.currentHumidity,
                        tomorrowMax: viewModel.tomorrowMax
                    )

                    // ── AI 경보 메시지 ──
                    if let message = viewModel.latestAlertMessage {
                        AlertMessageCard(message: message, level: viewModel.riskLevel)
                    }

                    // ── 대응 체크리스트 ──
                    if !viewModel.checklistItems.isEmpty {
                        ChecklistCard(
                            items: viewModel.checklistItems,
                            onToggle: viewModel.toggleChecklistItem
                        )
                    }

                    // ── 피해 신고 버튼 (위험 이상) ──
                    if viewModel.riskLevel >= .danger {
                        Button {
                            viewModel.showDamageReport = true
                        } label: {
                            Label("피해 신고하기", systemImage: "exclamationmark.triangle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.horizontal)
            }
            .navigationTitle("내 농장")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: Text("설정")) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .refreshable { await viewModel.refresh() }
            .task { await viewModel.refresh() }
            .sheet(isPresented: $viewModel.showDamageReport) {
                DamageReportView()
            }
            .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("확인") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

// MARK: - Sub Views

struct WeatherSummaryCard: View {
    let temperature: Double
    let humidity: Double
    let tomorrowMax: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("현재 기상")
                    .font(.headline)
                Spacer()
            }
            HStack(spacing: 24) {
                VStack {
                    Text("\(temperature, specifier: "%.1f")°C")
                        .font(.title.bold())
                    Text("현재 기온")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack {
                    Text("\(Int(humidity))%")
                        .font(.title.bold())
                    Text("습도")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if tomorrowMax > 0 {
                    VStack {
                        Text("\(tomorrowMax, specifier: "%.1f")°C")
                            .font(.title.bold())
                            .foregroundColor(.orange)
                        Text("내일 최고")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

struct AlertMessageCard: View {
    let message: String
    let level: RiskLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: level >= .danger ? "exclamationmark.triangle.fill" : "info.circle.fill")
                    .foregroundColor(level.color)
                Text("AI 경보 안내")
                    .font(.headline)
                    .foregroundColor(level.color)
            }
            Text(message)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(level.color.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(level.color.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ChecklistCard: View {
    let items: [ChecklistItem]
    let onToggle: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("대응 체크리스트")
                .font(.headline)

            ForEach(items) { item in
                Button { onToggle(item.id) } label: {
                    HStack(spacing: 12) {
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isCompleted ? .green : .secondary)
                            .font(.title3)
                        Text(item.text)
                            .font(.body)
                            .foregroundColor(.primary)
                            .strikethrough(item.isCompleted)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
