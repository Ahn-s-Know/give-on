import SwiftUI

struct MediaRegistrationView: View {
    @StateObject private var viewModel = MediaRegistrationViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                headerView

                // Content
                ScrollView {
                    VStack(spacing: 32) {
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("현장 사진을\n등록해주세요")
                                .font(.system(size: 28, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                                .tracking(-0.56)
                                .lineSpacing(4)

                            Text("정확한 피해 규모 파악을 위해 도움이 됩니다.")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Upload Area
                        VStack(spacing: 16) {
                            // Upload Button
                            Button(action: {
                                viewModel.selectMedia()
                            }) {
                                VStack(spacing: 7) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 27))
                                        .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))

                                    VStack(spacing: 4) {
                                        Text("사진/영상 추가하기")
                                            .font(.system(size: 17, weight: .medium, design: .default))
                                            .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))

                                        Text("최대 5개, 각 100MB 이하")
                                            .font(.system(size: 13, weight: .regular, design: .default))
                                            .foregroundColor(Color(UIColor(red: 0.435, green: 0.478, blue: 0.443, alpha: 1)))
                                    }
                                }
                                .frame(height: 160)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .border(Color(UIColor(red: 0.749, green: 0.788, blue: 0.753, alpha: 1)), width: 2)
                                .cornerRadius(12)
                            }

                            // Uploaded Items List
                            VStack(spacing: 12) {
                                ForEach(Array(viewModel.uploadedMedia.enumerated()), id: \.offset) { index, media in
                                    mediaItemView(media, index: index)
                                }

                                ForEach(Array(viewModel.uploadingMedia.enumerated()), id: \.offset) { index, media in
                                    uploadingItemView(media, index: index)
                                }
                            }
                        }

                        // Guide Text
                        HStack(spacing: 12) {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                                .frame(width: 20, height: 22)

                            VStack(alignment: .leading, spacing: 0) {
                                Text("최소 1장의 사진이 필요합니다. 식별이 가능한 밝은 곳에서 촬영한 사진을 권장합니다.")
                                    .font(.system(size: 13, weight: .medium, design: .default))
                                    .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                                    .lineSpacing(2)
                            }
                        }
                        .padding(16)
                        .background(Color(UIColor(red: 0.953, green: 0.956, blue: 0.929, alpha: 1)))
                        .cornerRadius(12)

                        Spacer(minLength: 80)
                    }
                    .padding(20)
                }
                .background(Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1)))

                Spacer()
            }

            // Bottom Buttons
            VStack {
                Spacer()

                HStack(spacing: 12) {
                    Button(action: {
                        // Skip action
                    }) {
                        Text("건너뛰기")
                            .font(.system(size: 17, weight: .medium, design: .default))
                            .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                            .frame(height: 52)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .border(Color(UIColor(red: 0.749, green: 0.788, blue: 0.753, alpha: 1)), width: 1)
                            .cornerRadius(999)
                    }

                    Button(action: {
                        // Next action
                    }) {
                        Text("다음")
                            .font(.system(size: 17, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .frame(height: 52)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                            .cornerRadius(999)
                    }
                    .disabled(viewModel.uploadedMedia.isEmpty)
                    .opacity(viewModel.uploadedMedia.isEmpty ? 0.6 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 17)
                .background(Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1)))
                .border(Color(UIColor(red: 0.898, green: 0.906, blue: 0.922, alpha: 1)), width: 1)
            }
        }
        .navigationBarHidden(true)
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
                        .foregroundColor(Color(UIColor(red: 0.114, green: 0.196, blue: 0.145, alpha: 1)))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }

                Text("사진 등록")
                    .font(.system(size: 24, weight: .medium, design: .default))
                    .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                    .tracking(-0.24)

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(Color(UIColor(red: 0.976, green: 0.976, blue: 0.953, alpha: 1)))
            .border(Color(UIColor(red: 0.898, green: 0.906, blue: 0.922, alpha: 1)), width: 1)
        }
    }

    private func mediaItemView(_ media: MediaItem, index: Int) -> some View {
        HStack(spacing: 0) {
            // Thumbnail
            ZStack {
                Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1))

                if let image = media.thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                }
            }
            .frame(width: 48, height: 48)
            .cornerRadius(6)
            .padding(.leading, 13)
            .padding(.trailing, 16)

            // File Info
            VStack(alignment: .leading, spacing: 4) {
                Text(media.name)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                    .lineLimit(1)

                Text("\(String(format: "%.1f", media.sizeInMB))MB")
                    .font(.system(size: 13, weight: .regular, design: .default))
                    .foregroundColor(Color(UIColor(red: 0.435, green: 0.478, blue: 0.443, alpha: 1)))
            }

            Spacer()

            // Remove Button
            Button(action: {
                viewModel.removeMedia(at: index)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .padding(.trailing, 13)
        }
        .frame(height: 74)
        .background(Color.white)
        .border(Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1)), width: 1)
        .cornerRadius(8)
    }

    private func uploadingItemView(_ media: UploadingMediaItem, index: Int) -> some View {
        HStack(spacing: 0) {
            // Thumbnail with overlay
            ZStack {
                Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1))

                Image(systemName: "video.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))

                Color(UIColor(red: 0.647, green: 0.953, blue: 0.773, alpha: 1))
                    .opacity(0.2)
            }
            .frame(width: 48, height: 48)
            .cornerRadius(6)
            .padding(12)

            // File Info + Progress
            VStack(alignment: .leading, spacing: 8) {
                Text(media.name)
                    .font(.system(size: 15, weight: .regular, design: .default))
                    .foregroundColor(Color(UIColor(red: 0.098, green: 0.110, blue: 0.094, alpha: 1)))
                    .lineLimit(1)

                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1))
                            .frame(height: 6)
                            .cornerRadius(999)

                        Color(UIColor(red: 0.000, green: 0.337, blue: 0.212, alpha: 1))
                            .frame(width: geometry.size.width * CGFloat(media.progress), height: 6)
                            .cornerRadius(999)
                    }
                }
                .frame(height: 6)
            }
            .padding(.trailing, 16)

            // Cancel Button
            Button(action: {
                viewModel.cancelUpload(at: index)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(UIColor(red: 0.247, green: 0.286, blue: 0.259, alpha: 1)))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .padding(.trailing, 13)
        }
        .frame(height: 74)
        .background(Color.white)
        .border(Color(UIColor(red: 0.882, green: 0.886, blue: 0.863, alpha: 1)), width: 1)
        .cornerRadius(8)
    }
}

extension View {
    var borderStyle: some View {
        self
    }
}

#Preview {
    MediaRegistrationView()
}
