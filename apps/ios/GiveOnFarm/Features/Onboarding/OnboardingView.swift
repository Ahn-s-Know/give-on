// OnboardingView.swift
// Give On Farm — 최초 실행 농장 등록 화면

import SwiftUI

struct OnboardingView: View {
    @Binding var onboardingCompleted: Bool

    @State private var name: String = ""
    @State private var ownerName: String = ""
    @State private var livestockType: String = "chicken"
    @State private var livestockCount: String = ""
    @State private var location: String = ""
    @State private var phoneNumber: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    private let livestockTypes = [
        ("chicken", "닭 (육계·산란계)"),
        ("pig", "돼지"),
        ("cattle", "한우·젖소"),
        ("duck", "오리"),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(spacing: 4) {
                        Image(systemName: "leaf.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        Text("Give On Farm")
                            .font(.title.bold())
                        Text("농장 정보를 등록하면 맞춤 기상 경보를 받을 수 있습니다.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .listRowBackground(Color.clear)
                }

                Section("농장 정보") {
                    TextField("농장명", text: $name)
                    TextField("농가주 이름", text: $ownerName)
                    TextField("주소 (시·군·구 단위)", text: $location)
                    TextField("전화번호", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }

                Section("축종 및 규모") {
                    Picker("축종", selection: $livestockType) {
                        ForEach(livestockTypes, id: \.0) { key, label in
                            Text(label).tag(key)
                        }
                    }
                    HStack {
                        Text("사육 규모")
                        Spacer()
                        TextField("0", text: $livestockCount)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("두(수)")
                    }
                }

                Section {
                    Button {
                        registerFarm()
                    } label: {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("등록하고 시작하기")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid || isLoading)
                }
            }
            .navigationTitle("농장 등록")
            .alert("오류", isPresented: .constant(errorMessage != nil)) {
                Button("확인") { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private var isFormValid: Bool {
        !name.isEmpty && !ownerName.isEmpty && !location.isEmpty && !livestockCount.isEmpty
    }

    private func registerFarm() {
        guard let count = Int(livestockCount) else { return }
        isLoading = true

        Task {
            do {
                let body = FarmCreateRequest(
                    name: name,
                    ownerName: ownerName,
                    livestockType: livestockType,
                    livestockCount: count,
                    location: location,
                    latitude: nil,
                    longitude: nil,
                    phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber
                )
                let farm = try await APIClient.shared.registerFarm(body: body)

                UserDefaultsManager.shared.farmId = farm.id
                UserDefaultsManager.shared.farmName = farm.name
                UserDefaultsManager.shared.livestockType = farm.livestockType
                UserDefaultsManager.shared.livestockCount = farm.livestockCount
                UserDefaultsManager.shared.onboardingCompleted = true

                await MainActor.run { onboardingCompleted = true }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    OnboardingView(onboardingCompleted: .constant(false))
}
