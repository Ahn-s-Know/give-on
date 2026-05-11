import SwiftUI

struct CampaignConfirmationModal: View {
    @StateObject private var viewModel: CampaignConfirmationViewModel
    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}

    init(campaignTitle: String, onConfirm: @escaping () -> Void = {}, onCancel: @escaping () -> Void = {}) {
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        _viewModel = StateObject(wrappedValue: CampaignConfirmationViewModel(campaignTitle: campaignTitle))
    }

    var body: some View {
        ZStack {
            // Modal Overlay
            Color.gof.black.opacity(0.4)

            // Modal Dialog
            VStack(spacing: .gof.xl) {
                // Modal Header
                VStack(spacing: .gof.md) {
                    // Icon
                    Image(systemName: "person.badge.plus")
                        .font(.gof.iconLarge)
                        .foregroundColor(.gof.iconGreen)
                        .frame(width: .gof.iconSuccess, height: .gof.iconSuccess)
                        .background(Color.gof.lightGreen)
                        .cornerRadius(.gof.iconBack)

                    // Title
                    Text("캠페인 생성 요청 하시겠습니까?")
                        .font(.gof.titleRegular)
                        .foregroundColor(.gof.textPrimary)
                        .multilineTextAlignment(.center)
                }

                // Modal Content
                VStack(spacing: 11) {
                    // Description
                    VStack(spacing: 0) {
                        Text("신고하신 내용을 바탕으로 시민 참여를 유도하는 모금 캠페인이 개설됩니다.")
                            .font(.gof.body)
                            .foregroundColor(.gof.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }

                    // Campaign Title Preview
                    HStack(spacing: .gof.sm) {
                        Image(systemName: "speaker.wave.2")
                            .font(.gof.icon)
                            .foregroundColor(.gof.textPrimary)
                            .frame(width: .gof.iconMedium, height: .gof.iconSmall)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("캠페인 제목 미리보기")
                                .font(.gof.caption)
                                .foregroundColor(.gof.textSecondary)

                            Text(viewModel.campaignTitle)
                                .font(.gof.subtitleRegular)
                                .foregroundColor(.gof.textPrimary)
                                .lineLimit(2)
                        }

                        Spacer()
                    }
                    .padding(.gof.md - 3)
                    .background(Color.gof.white)
                    .cornerRadius(.gof.radiusMedium)
                    .overlay(
                        RoundedRectangle(cornerRadius: .gof.radiusMedium)
                            .stroke(Color.gof.borderDefault, lineWidth: .gof.borderThin)
                    )

                    // Notice
                    VStack(spacing: 0) {
                        Text("* 관리자 검수 후 최종 승인됩니다.")
                            .font(.gof.caption)
                            .foregroundColor(.gof.textPlaceholder)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.gof.md + 1)
                .background(Color.gof.backgroundCard)
                .cornerRadius(.gof.radiusLarge)
                .overlay(
                    RoundedRectangle(cornerRadius: .gof.radiusLarge)
                        .stroke(Color.gof.borderDivider, lineWidth: .gof.borderThin)
                )

                // Modal Actions
                HStack(spacing: .gof.sm) {
                    Button("취소", action: onCancel)
                        .gofSecondaryButton()

                    Button("확인", action: onConfirm)
                        .gofPrimaryButton()
                }
                .padding(.top, .gof.xs)
            }
            .padding(.gof.xl)
            .background(Color.gof.white)
            .cornerRadius(.gof.radiusXLarge)
            .shadow(color: .gof.black.opacity(0.12), radius: 12, x: 0, y: 8)
            .padding(.gof.lg)
        }
    }
}

#Preview {
    CampaignConfirmationModal(
        campaignTitle: "긴급: 경북 포항시 폭우 피해 농가",
        onConfirm: { print("Confirmed") },
        onCancel: { print("Cancelled") }
    )
}
