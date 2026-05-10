import SwiftUI

struct FarmRegistrationEntryView: View {
    @Binding var isRegistered: Bool
    @State private var isVoiceMode = false
    @State private var isManualMode = false

    var body: some View {
        ZStack {
            Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)

                VStack(spacing: 12) {
                    Text("Give On")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)

                    Text("농장 등록")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()
                    .frame(height: 40)

                VStack(spacing: 12) {
                    Text("등록이 어려우신가요?")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)

                    Text("음성 입력 버튼을 누르고 말씀하시면\n자동으로 등록됩니다.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }

                Spacer()
                    .frame(height: 40)

                VStack(spacing: 12) {
                    Button(action: { isVoiceMode = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 18))
                            Text("음성으로 등록")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                        .cornerRadius(28)
                    }

                    VStack(spacing: 4) {
                        Button(action: { isManualMode = true }) {
                            Text("직접 입력")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)), lineWidth: 1)
                                )
                        }
                        Text("Give On App v1.0")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)

                Spacer()
            }

            if isVoiceMode {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Text("음성 입력")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)

                        Image(systemName: "mic.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))

                        Text("말씀해주세요")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(16)

                    Spacer()

                    Button(action: { isVoiceMode = false }) {
                        Text("닫기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                            .cornerRadius(12)
                    }
                    .padding(16)
                }
            }

            if isManualMode {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("직접 입력")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TextField("농장명 입력", text: .constant(""))
                            .font(.system(size: 15))
                            .padding(12)
                            .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
                            .cornerRadius(8)

                        TextField("위치 입력", text: .constant(""))
                            .font(.system(size: 15))
                            .padding(12)
                            .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(16)

                    Spacer()

                    HStack(spacing: 12) {
                        Button(action: { isManualMode = false }) {
                            Text("취소")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
                                .cornerRadius(12)
                        }

                        Button(action: {}) {
                            Text("완료")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                                .cornerRadius(12)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

#Preview {
    FarmRegistrationEntryView(isRegistered: .constant(false))
}
