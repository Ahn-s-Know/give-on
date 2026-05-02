// DamageReportView.swift
// Give On Farm — 피해 신고 폼

import SwiftUI

struct DamageReportView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var deadCount: String = ""
    @State private var cause: String = "heatwave"
    @State private var estimatedLoss: String = ""
    @State private var farmerNote: String = ""
    @State private var isSubmitting = false
    @State private var submitted = false

    private let causes = [
        ("heatwave", "폭염"),
        ("cold_wave", "한파"),
        ("storm", "폭설·강풍"),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("피해 현황") {
                    HStack {
                        Text("폐사 두수")
                        Spacer()
                        TextField("0", text: $deadCount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("마리")
                    }

                    Picker("피해 원인", selection: $cause) {
                        ForEach(causes, id: \.0) { key, label in
                            Text(label).tag(key)
                        }
                    }

                    HStack {
                        Text("추정 피해액")
                        Spacer()
                        TextField("0", text: $estimatedLoss)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("원")
                    }
                }

                Section("한마디") {
                    TextEditor(text: $farmerNote)
                        .frame(minHeight: 80)
                        .overlay(
                            Group {
                                if farmerNote.isEmpty {
                                    Text("어려운 상황을 간단히 적어주세요...")
                                        .foregroundColor(.gray)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                }

                Section {
                    Text("신고가 접수되면 AI가 기부 페이지 스토리를 자동으로 생성합니다.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("피해 신고")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("신고하기") { submitReport() }
                        .disabled(deadCount.isEmpty || isSubmitting)
                        .bold()
                }
            }
            .disabled(isSubmitting)
            .overlay {
                if isSubmitting {
                    ProgressView("신고 접수 중...")
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .alert("신고 완료", isPresented: $submitted) {
                Button("확인") { dismiss() }
            } message: {
                Text("피해 신고가 접수되었습니다. 기부 페이지가 곧 생성됩니다.")
            }
        }
    }

    private func submitReport() {
        guard let farmId = UserDefaultsManager.shared.farmId,
              let count = Int(deadCount) else { return }

        isSubmitting = true
        Task {
            let report = DamageReportCreate(
                farmId: farmId,
                deadCount: count,
                cause: cause,
                estimatedLoss: Int(estimatedLoss),
                farmerNote: farmerNote.isEmpty ? nil : farmerNote
            )
            await APIClient.shared.submitDamageReport(report)
            isSubmitting = false
            submitted = true
        }
    }
}

// MARK: - Wrapper

extension APIClient {
    func submitDamageReport(_ body: DamageReportCreate) async {
        _ = try? await submitDamageReport(body)
    }
}

#Preview {
    DamageReportView()
}
