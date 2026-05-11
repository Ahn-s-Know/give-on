import SwiftUI

struct DamageReportCompletionView: View {
    @StateObject private var viewModel = DamageReportCompletionViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Background
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gof.backgroundPrimary,
                        Color.gof.white
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            VStack(spacing: 0) {
                // Main Content
                VStack(spacing: .gof.xxl) {
                    // Success Icon
                    GOFSuccessIcon()
                        .padding(.bottom, .gof.md)

                    // Title
                    Text("피해 신고가 완료되었습니다")
                        .font(.gof.largeTitle)
                        .foregroundColor(.gof.textPrimary)
                        .tracking(-0.24)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, .gof.xs)

                    // Description
                    VStack(spacing: 7) {
                        Text("관리자가 확인 후 검수 과정을 진행합니다.")
                            .font(.gof.body)
                            .foregroundColor(.gof.textTertiary)

                        Text("예상 소요 시간 : 1-2일")
                            .font(.gof.body)
                            .foregroundColor(.gof.textTertiary)
                    }
                    .multilineTextAlignment(.center)

                    Spacer(minLength: 100)
                }
                .frame(maxWidth: 448)
                .padding(.horizontal, .gof.lg)
                .padding(.vertical, 265)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            // Bottom Action Button
            VStack {
                Spacer()

                VStack {
                    Button {
                        viewModel.returnHome()
                    } label: {
                        Text("홈으로 돌아가기")
                            .foregroundColor(.gof.lightGreenText)
                    }
                    .gofPrimaryButton()
                }
                .padding(.gof.lg)
                .background(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.gof.backgroundPrimary.opacity(0), location: 0),
                            .init(color: Color.gof.backgroundPrimary, location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DamageReportCompletionView()
}
