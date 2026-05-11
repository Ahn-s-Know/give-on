import SwiftUI

struct DamageInformationView: View {
    @StateObject private var viewModel = DamageInformationViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                GOFHeader(title: "피해 신고") {
                    presentationMode.wrappedValue.dismiss()
                }

                // Content
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: .gof.xxl) {
                            // Step Indicator
                            GOFStepIndicator(currentStep: 2, totalSteps: 3)

                            // Title Section
                            VStack(alignment: .leading, spacing: .gof.xs) {
                                Text("어떤 피해를 입으셨나요?")
                                    .font(.gof.title)
                                    .foregroundColor(.gof.textPrimary)

                                Text("정확한 피해 규모 산정을 위해 상세히 입력해주세요.")
                                    .font(.gof.body)
                                    .foregroundColor(.gof.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            // Crop Selection
                            VStack(alignment: .leading, spacing: .gof.sm) {
                                GOFSectionTitle("피해 작물 선택", isRequired: true)

                                cropsGrid
                            }

                            // Damage Scale
                            VStack(alignment: .leading, spacing: .gof.sm) {
                                GOFSectionTitle("피해 규모 (예상)", isRequired: true)

                                // Input Field
                                GOFTextField(
                                    placeholder: "피해 면적 입력",
                                    text: $viewModel.damageArea,
                                    suffix: "평",
                                    keyboardType: .numberPad
                                )

                                // Quick Select Buttons
                                HStack(spacing: .gof.xs) {
                                    quickSelectButton("100평", value: "100")
                                    quickSelectButton("500평", value: "500")
                                    quickSelectButton("1000평", value: "1000")
                                }
                            }

                            // Main Symptoms
                            VStack(alignment: .leading, spacing: .gof.sm) {
                                Text("주요 피해 증상 (다중 선택 가능)")
                                    .font(.gof.subtitle)
                                    .foregroundColor(.gof.textPrimary)

                                VStack(spacing: .gof.xs) {
                                    symptomCheckBox("낙과 (열매 떨어짐)", id: "falling")
                                    symptomCheckBox("도복 (쓰러짐)", id: "lodging")
                                    symptomCheckBox("침수 (물에 잠김)", id: "flooding")
                                    symptomCheckBox("병충해 발생", id: "disease")
                                }
                            }

                            // Additional Notes
                            VStack(alignment: .leading, spacing: .gof.sm) {
                                Text("추가 설명 (선택)")
                                    .font(.gof.subtitle)
                                    .foregroundColor(.gof.textPrimary)

                                GOFTextEditor(
                                    placeholder: "기타 특이사항이나 상세한 피해 상황을 적어주세요.",
                                    text: $viewModel.additionalNotes
                                )
                            }

                            Spacer(minLength: 80)
                        }
                        .padding(.gof.lg)
                    }
                }
                .background(Color.gof.backgroundPrimary)

                Spacer()
            }

            // Bottom Button
            VStack {
                Spacer()

                Button {
                    viewModel.nextStep()
                } label: {
                    Text("다음 단계로")
                }
                .gofPrimaryButton(isEnabled: viewModel.isValid)
                .padding(.gof.lg)
                .background(Color.gof.white)
                .overlay(
                    Rectangle()
                        .fill(Color.gof.borderDivider)
                        .frame(height: .gof.borderThin),
                    alignment: .top
                )
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Subviews

    // headerView는 더 이상 필요 없음 - GOFHeader 사용

    private var cropsGrid: some View {
        let crops = ["사과", "배", "복숭아", "포도", "기타 작물"]
        var gridItems: [GridItem] = []
        for _ in 0..<2 {
            gridItems.append(GridItem(.flexible(), spacing: 8))
        }

        return LazyVGrid(columns: gridItems, spacing: 8) {
            ForEach(crops, id: \.self) { crop in
                cropButton(crop)
            }
        }
    }

    private func cropButton(_ crop: String) -> some View {
        Button {
            viewModel.selectedCrop = crop
        } label: {
            Text(crop)
        }
        .gofOutlineButton(isSelected: viewModel.selectedCrop == crop)
    }

    private func quickSelectButton(_ title: String, value: String) -> some View {
        Button {
            viewModel.damageArea = value
        } label: {
            Text(title)
        }
        .gofSmallButton()
    }

    private func symptomCheckBox(_ title: String, id: String) -> some View {
        Button {
            if viewModel.selectedSymptoms.contains(id) {
                viewModel.selectedSymptoms.remove(id)
            } else {
                viewModel.selectedSymptoms.insert(id)
            }
        } label: {
            Text(title)
        }
        .gofCheckboxButton(isSelected: viewModel.selectedSymptoms.contains(id))
    }
}

#Preview {
    DamageInformationView()
}
