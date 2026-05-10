import SwiftUI

/// 캠페인 목록 화면
struct CampaignListView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Text("캠페인")
                    .font(.gof.largeTitle)
                    .foregroundColor(.gof.textPrimary)
                    .tracking(-0.24)
                
                Spacer()
                
                Button {
                    // 검색 액션
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.gof.icon)
                        .foregroundColor(.gof.textPrimary)
                }
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
                VStack(spacing: .gof.md) {
                    // 진행 중인 캠페인 섹션
                    VStack(alignment: .leading, spacing: .gof.md) {
                        Text("진행 중인 캠페인")
                            .font(.gof.subtitle)
                            .foregroundColor(.gof.textPrimary)
                            .padding(.horizontal, .gof.lg)
                        
                        // 캠페인 카드 예시
                        campaignCard(
                            title: "긴급: 경북 포항시 폭우 피해 농가",
                            description: "30년 가꾼 사과밭이 폭우로 침수되었습니다.",
                            progress: 0.65,
                            current: "6,500,000",
                            goal: "10,000,000"
                        )
                        
                        campaignCard(
                            title: "충남 예산군 우박 피해 복구 지원",
                            description: "배 농장의 우박 피해 복구를 도와주세요.",
                            progress: 0.42,
                            current: "4,200,000",
                            goal: "10,000,000"
                        )
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.vertical, .gof.lg)
            }
            .background(Color.gof.backgroundPrimary)
        }
    }
    
    // MARK: - Subviews
    
    private func campaignCard(title: String, description: String, progress: Double, current: String, goal: String) -> some View {
        VStack(alignment: .leading, spacing: .gof.md) {
            // 제목 및 설명
            VStack(alignment: .leading, spacing: .gof.xs) {
                Text(title)
                    .font(.gof.subtitleMedium)
                    .foregroundColor(.gof.textPrimary)
                    .lineLimit(2)
                
                Text(description)
                    .font(.gof.body)
                    .foregroundColor(.gof.textSecondary)
                    .lineLimit(2)
            }
            
            // 진행 바
            VStack(alignment: .leading, spacing: .gof.xs) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gof.borderDivider)
                            .frame(height: 8)
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(Color.gof.primaryGreen)
                            .frame(width: geometry.size.width * progress, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
                
                HStack {
                    Text("\(current)원")
                        .font(.gof.bodyBold)
                        .foregroundColor(.gof.primaryGreen)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.gof.caption)
                        .foregroundColor(.gof.textSecondary)
                }
            }
        }
        .padding(.gof.md)
        .background(Color.gof.white)
        .cornerRadius(.gof.radiusLarge)
        .padding(.horizontal, .gof.lg)
    }
}

#Preview {
    CampaignListView()
}
