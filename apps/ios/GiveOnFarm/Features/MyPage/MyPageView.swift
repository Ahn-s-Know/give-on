import SwiftUI

struct MyPageView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Text("Give On")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "bell")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                }
                .padding(16)
                .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))

                ScrollView {
                    VStack(spacing: 20) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("김지수님")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                                Text("포천 왓살농장")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Image(systemName: "pencil")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                        HStack(spacing: 12) {
                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    Image(systemName: "hourglass.badge.plus")
                                        .font(.system(size: 14))
                                    Text("진행중 캠페인")
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(.gray)

                                Text("2")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                Text("건")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(12)

                            VStack(spacing: 8) {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 14))
                                    Text("완료된 캠페인")
                                        .font(.system(size: 13))
                                }
                                .foregroundColor(.gray)

                                Text("14")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                                Text("건")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)

                        VStack(spacing: 0) {
                            menuItem(icon: "building.2.fill", title: "Give On 공지사항")
                            Divider().padding(.horizontal, 16)
                            menuItem(icon: "gearshape.fill", title: "계정 설정")
                            Divider().padding(.horizontal, 16)
                            menuItem(icon: "headphones.circle.fill", title: "고객센터")
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                        Spacer()
                    }
                    .padding(.top, 16)
                }

                HStack(spacing: 24) {
                    tabBarIcon(icon: "house.fill", label: "홈")
                    tabBarIcon(icon: "location.fill", label: "피해신고")
                    tabBarIcon(icon: "doc.fill", label: "인쇄여행")
                    tabBarIcon(icon: "gearshape.fill", label: "설정")
                }
                .frame(height: 60)
                .background(Color(UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)))
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }

    private func menuItem(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))
                .frame(width: 24)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(16)
    }

    private func tabBarIcon(icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(UIColor(red: 0.122, green: 0.435, blue: 0.290, alpha: 1)))

            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyPageView()
}
