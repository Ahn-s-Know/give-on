import SwiftUI

struct DamageReportInputMethodView: View {
    @StateObject private var viewModel = DamageReportInputMethodViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToManualInput = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                headerView

                // Content
                ZStack {
                    VStack(spacing: 0) {
                        // Decorative Elements
                        ZStack {
                            Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1))

                            // Blur circles (simulated with gradient)
                            Circle()
                                .fill(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                                .frame(width: 195, height: 195)
                                .blur(radius: 32)
                                .offset(x: -100, y: -150)
                                .opacity(0.1)

                            Circle()
                                .fill(Color(UIColor(red: 0.549, green: 0.322, blue: 0.286, alpha: 1)))
                                .frame(width: 156, height: 156)
                                .blur(radius: 32)
                                .offset(x: 100, y: 150)
                                .opacity(0.1)
                        }

                        Spacer()
                    }

                    // Main Content
                    VStack(spacing: 48) {
                        // Title Section
                        VStack(spacing: 12) {
                            Text("어떤 방식으로\n등록하시겠어요?")
                                .font(.system(size: 24, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                                .tracking(-0.24)
                                .lineSpacing(8)
                                .multilineTextAlignment(.center)

                            Text("음성으로 간편하게 AI가 신고를 도와줍니다.")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor(red: 0.369, green: 0.369, blue: 0.357, alpha: 1)))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: 300)

                        // Action Buttons
                        VStack(spacing: 16) {
                            // Voice Input Button
                            Button(action: {
                                viewModel.selectVoiceInput()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "mic.fill")
                                        .font(.system(size: 14, weight: .semibold))

                                    Text("음성으로 신고")
                                        .font(.system(size: 17, weight: .medium, design: .default))
                                }
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                                .cornerRadius(999)
                                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                            }

                            // Manual Input Button
                            Button(action: {
                                viewModel.selectManualInput()
                                navigateToManualInput = true
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .semibold))

                                    Text("직접 입력")
                                        .font(.system(size: 17, weight: .medium, design: .default))
                                }
                                .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                                .frame(height: 56)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .border(Color(UIColor(red: 0.749, green: 0.788, blue: 0.753, alpha: 1)), width: 1)
                                .cornerRadius(999)
                            }
                        }
                        .frame(maxWidth: 300)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $navigateToManualInput) {
            // 직접 입력 플로우로 이동
            DamageInformationView()
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor(red: 0.000, green: 0.337, blue: 0.212, alpha: 1)))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }

                Text("Give On")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(Color(UIColor(red: 0.000, green: 0.337, blue: 0.212, alpha: 1)))

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1)))
            .border(Color(UIColor(red: 0.898, green: 0.906, blue: 0.922, alpha: 1)), width: 1)
        }
    }
}

#Preview {
    DamageReportInputMethodView()
}
