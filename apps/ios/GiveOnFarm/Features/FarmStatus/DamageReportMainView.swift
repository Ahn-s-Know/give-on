import SwiftUI

/// 피해 신고 메인 화면 (탭바용)
struct DamageReportMainView: View {
    @State private var showReportFlow = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Text("피해 신고")
                        .font(.gof.largeTitle)
                        .foregroundColor(.gof.textPrimary)
                        .tracking(-0.24)
                    
                    Spacer()
                }
                .padding(.horizontal, .gof.lg)
                .frame(height: .gof.heightHeader)
                .background(Color.gof.white)
                .overlay(
                    Rectangle()
                        .fill(Color.gof.borderDivider)
                        .frame(height: .gof.borderThin),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: .gof.xxl) {
                        // 정보 배너
                        GOFInfoBanner(
                            icon: "exclamationmark.triangle.fill",
                            title: "농작물 피해를 신고하세요",
                            description: "자연재해로 인한 농작물 피해를 신고하고 지원을 받으세요. 신고 내용을 바탕으로 모금 캠페인이 개설될 수 있습니다."
                        )
                        
                        // 신고 시작 버튼
                        Button {
                            showReportFlow = true
                        } label: {
                            Text("피해 신고 시작하기")
                        }
                        .gofPrimaryButton()
                        
                        // 최근 신고 내역 (예시)
                        VStack(alignment: .leading, spacing: .gof.md) {
                            Text("최근 신고 내역")
                                .font(.gof.subtitle)
                                .foregroundColor(.gof.textPrimary)
                            
                            Text("아직 신고 내역이 없습니다.")
                                .font(.gof.body)
                                .foregroundColor(.gof.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, .gof.xxl)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.gof.lg)
                }
                .background(Color.gof.backgroundPrimary)
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showReportFlow) {
                // 피해 신고 플로우 시작
                DamageLocationView()
            }
        }
    }
}

#Preview {
    DamageReportMainView()
}
