import SwiftUI

/// 캠페인 목록 화면
struct CampaignListView: View {
    @State private var campaigns: [Campaign] = []
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Text("캠페인")
                    .font(.gof.largeTitle)
                    .foregroundColor(.gof.textPrimary)
                    .tracking(-0.24)

                Spacer()

                Button {
                    // 알림
                } label: {
                    Image(systemName: "bell")
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
                
                // 콘텐츠
                ScrollView {
                    VStack(spacing: .gof.lg) {
                        // 진행 중인 캠페인
                        VStack(alignment: .leading, spacing: .gof.md) {
                            Text("진행 중인 캠페인")
                                .font(.gof.subtitle)
                                .foregroundColor(.gof.textPrimary)
                            
                            if campaigns.isEmpty {
                                emptyStateView
                            } else {
                                ForEach(campaigns) { campaign in
                                    campaignCard(campaign)
                                }
                            }
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.gof.lg)
                }
                .background(Color.gof.backgroundPrimary)
        }
        .background {
            VStack(spacing: 0) {
                Color.gof.white
                Color.gof.backgroundPrimary
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack(spacing: .gof.md) {
            Image(systemName: "megaphone")
                .font(.system(size: 48))
                .foregroundColor(.gof.textSecondary)
            
            Text("진행 중인 캠페인이 없습니다")
                .font(.gof.body)
                .foregroundColor(.gof.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, .gof.xxl * 2)
    }
    
    private func campaignCard(_ campaign: Campaign) -> some View {
        GOFCard {
            VStack(alignment: .leading, spacing: .gof.md) {
                Text(campaign.title)
                    .font(.gof.subtitle)
                    .foregroundColor(.gof.textPrimary)
                
                Text(campaign.description)
                    .font(.gof.body)
                    .foregroundColor(.gof.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Text("\(campaign.currentAmount)원 / \(campaign.goalAmount)원")
                        .font(.gof.captionBold)
                        .foregroundColor(.gof.primaryGreen)
                    
                    Spacer()
                    
                    Text("\(campaign.participantCount)명 참여")
                        .font(.gof.caption)
                        .foregroundColor(.gof.textSecondary)
                }
            }
        }
    }
}

// MARK: - Models

struct Campaign: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let currentAmount: Int
    let goalAmount: Int
    let participantCount: Int
    let riskLevel: String
    let region: String
    let livestockType: String

    var progressRatio: Double {
        guard goalAmount > 0 else { return 0 }
        return min(Double(currentAmount) / Double(goalAmount), 1.0)
    }
}

// MARK: - Preview

#Preview {
    CampaignListView()
}
