import SwiftUI

struct CampaignStoryCreationView: View {
    @StateObject private var viewModel = CampaignStoryCreationViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                GOFHeader(title: "캠페인 스토리") {
                    presentationMode.wrappedValue.dismiss()
                }

                // Content
                ScrollView {
                    VStack(spacing: .gof.xxl) {
                        // Context Banner
                        GOFInfoBanner(
                            icon: "lightbulb.fill",
                            title: "AI가 스토리를 다듬어 드립니다.",
                            description: "어려웠던 일, 필요한 도움을 편하게 적어주세요. 더 많은 시민들이 공감할 수 있는 글로 AI가 정리해 줍니다."
                        )

                        // Text Input Section
                        VStack(alignment: .leading, spacing: .gof.xs) {
                            Text("농가의 이야기")
                                .font(.gof.titleMedium)
                                .foregroundColor(.gof.textPrimary)

                            GOFTextEditor(
                                placeholder: """
                                예: 이번 폭우로 30년 가꾼 사과밭이 많이 망가
                                졌습니다. 당장 복구할 인력이 부족해서 막막하
                                네요. 못난이 사과라도 수확해서 다시 일어설
                                힘을 얻고 싶습니다...
                                """,
                                text: $viewModel.storyText,
                                minHeight: 160,
                                maxCharacters: 500
                            )
                        }

                        // Photo Upload Section
                        photoUploadSection

                        // Voice Input Option
                        VStack(spacing: 25) {
                            Divider()
                                .background(Color.gof.borderDivider)

                            VStack(spacing: .gof.md) {
                                Text("글쓰기가 어려우신가요?")
                                    .font(.gof.captionMedium)
                                    .foregroundColor(.gof.textSecondary)

                                Button {
                                    viewModel.startVoiceInput()
                                } label: {
                                    HStack(spacing: .gof.xs) {
                                        Image(systemName: "mic.fill")
                                            .font(.gof.iconSmall)

                                        Text("음성으로 이야기하기")
                                    }
                                }
                                .gofGrayButton()
                            }
                        }

                        Spacer(minLength: .gof.xxl)
                    }
                    .padding(.horizontal, .gof.lg)
                    .padding(.vertical, .gof.xl)
                    .padding(.bottom, 128)
                }
                .background(Color.gof.backgroundPrimary)

                Spacer()
            }

            // Bottom Action Button (Sticky)
            VStack {
                Spacer()

                VStack {
                    Button {
                        viewModel.submitStory()
                    } label: {
                        Text("AI 스토링 정리하기")
                    }
                    .gofPrimaryButton(isEnabled: !viewModel.storyText.isEmpty)
                }
                .padding(.gof.lg)
                .background(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .gof.white.opacity(0), location: 0),
                            .init(color: .gof.white, location: 0.5),
                            .init(color: .gof.white, location: 1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Subviews
    // headerView, contextBanner, textInputSection, voiceInputOption는 더 이상 필요 없음

    private var photoUploadSection: some View {
        VStack(alignment: .leading, spacing: .gof.xs) {
            Text("현장 사진 (선택)")
                .font(.gof.titleMedium)
                .foregroundColor(.gof.textPrimary)

            Text("피해 현장이나 농작물 사진을 올리면 더 많은 참여를 이끌어낼 수 있습니다.")
                .font(.gof.captionMedium)
                .foregroundColor(.gof.textTertiary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .gof.xs) {
                    Button {
                        viewModel.selectPhoto()
                    } label: {
                        VStack(spacing: 3) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 18))
                                .foregroundColor(.gof.textSecondary)

                            Text("사진 추가")
                                .font(.gof.captionMedium)
                                .foregroundColor(.gof.textSecondary)
                        }
                        .frame(width: 96, height: 96)
                        .background(Color.gof.white)
                        .cornerRadius(.gof.radiusLarge)
                        .dashedBorder(color: .gof.borderDefault, width: .gof.borderThick)
                    }

                    ForEach(viewModel.selectedPhotos, id: \.self) { photo in
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipped()
                            .cornerRadius(.gof.radiusLarge)
                    }
                }
                .padding(.horizontal, .gof.lg)
                .padding(.vertical, .gof.md)
            }
            .frame(height: 104)
            .background(Color.gof.backgroundPrimary)
            .offset(x: -.gof.lg)
        }
    }

    private var voiceInputOption: some View {
        VStack(spacing: 25) {
            Divider()
                .background(Color.gof.borderDivider)

            VStack(spacing: .gof.md) {
                Text("글쓰기가 어려우신가요?")
                    .font(.gof.captionMedium)
                    .foregroundColor(.gof.textSecondary)

                Button {
                    viewModel.startVoiceInput()
                } label: {
                    HStack(spacing: .gof.xs) {
                        Image(systemName: "mic.fill")
                            .font(.gof.iconSmall)

                        Text("음성으로 이야기하기")
                            .font(.gof.button)
                    }
                    .foregroundColor(.gof.textDisabled)
                    .frame(maxWidth: .infinity)
                    .frame(height: .gof.heightMedium)
                    .background(Color.gof.backgroundGray)
                    .cornerRadius(.gof.radiusFull)
                }
            }
        }
    }
}

#Preview {
    CampaignStoryCreationView()
}
