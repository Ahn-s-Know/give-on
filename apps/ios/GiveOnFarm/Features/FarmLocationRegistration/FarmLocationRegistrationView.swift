import SwiftUI

struct FarmLocationRegistrationView: View {
    @State private var searchText = ""
    @State private var selectedLocation = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                }

                Spacer()

                Text("농장 등록")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Color.clear
                    .frame(width: 40)
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color.white)
            .border(Color(UIColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1)), width: 1)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("2/2 농장 위치")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("농장 주소를 입력해주세요")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)

                        Text("정확한 주소는 피해 지원에 도움이 됩니다.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)

                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "location.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(UIColor(red: 0.549, green: 0.886, blue: 0.706, alpha: 1)))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("현재 위치로 찾기")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)

                                Text("현재 계신 곳이 농장이라면 선택해주세요.")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .background(Color(UIColor(red: 0.925, green: 0.973, blue: 0.949, alpha: 1)))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)

                    HStack {
                        Text("또는")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)

                            TextField("도로명 또는 지번 주소 입력", text: $searchText)
                                .font(.system(size: 15))
                                .foregroundColor(.black)

                            Button(action: {}) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(12)
                        .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
                        .cornerRadius(8)

                        Text("주소 직접 검색")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)

                    VStack(spacing: 12) {
                        Image(systemName: "map.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)

                        Text("지도에서 위치를\n직접 선택할 수 있습니다.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)

                    Spacer()
                        .frame(height: 20)
                }
            }

            HStack {
                Button(action: {}) {
                    Text("완료")
                        .font(.system(size: 17, weight: .semibold))
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

#Preview {
    FarmLocationRegistrationView()
}
