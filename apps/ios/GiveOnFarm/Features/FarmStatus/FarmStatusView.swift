import SwiftUI

/// 농장 상태 홈 화면
struct FarmStatusView: View {
    @StateObject private var viewModel = FarmStatusViewModel()
    @State private var isPulsing = false
    @State private var showDamageReport = false

    private var isEmergency: Bool { viewModel.riskLevel == .emergency }

    private var fgPrimary: Color { isEmergency ? .gof.onDark : .gof.textPrimary }
    private var fgSecondary: Color { isEmergency ? .gof.onDark.opacity(0.65) : .gof.textSecondary }
    private var bgPage: Color { isEmergency ? .gof.surfaceDark : .gof.backgroundPrimary }
    private var bgCard: Color {
        isEmergency
            ? Color(UIColor(red: 0.15, green: 0.25, blue: 0.18, alpha: 1))
            : .gof.white
    }
    private var cardBorder: Color {
        isEmergency ? .gof.onDark.opacity(0.2) : .gof.borderDivider
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                VStack(spacing: .gof.xxl) {
                    riskIndicatorSection
                    weatherCard
                    
                    if viewModel.riskLevel >= .danger {
                        if let message = viewModel.alertMessage {
                            alertMessageCard(message)
                        }
                        
                        if !viewModel.checklistItems.isEmpty {
                            checklistSection
                        }
                        
                        damageReportButton
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.top, .gof.xl)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.pink)
                        .background(bgPage)
        }
        .padding(0)
        .background(bgPage)
//        .background(Color.blue)
        .onChange(of: viewModel.riskLevel) { level in
            if level == .emergency {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            } else {
                isPulsing = false
            }
        }
        .fullScreenCover(isPresented: $showDamageReport) {
            DamageReportInputMethodView()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Text("Give On")
                .font(.gof.subtitle)
                .foregroundColor(fgPrimary)

            Spacer()

            Button {
                // 알림
            } label: {
                Image(systemName: "bell")
                    .font(.gof.icon)
                    .foregroundColor(fgPrimary)
            }
        }
        .padding( .gof.md)
        .background(isEmergency ? Color.gof.surfaceDark : Color.gof.white)
        .overlay(
            Rectangle()
                .fill(isEmergency ? Color.clear : Color.gof.borderDivider)
                .frame(height: .gof.borderThin),
            alignment: .bottom
        )
    }

    // MARK: - Risk Indicator

    private var riskIndicatorSection: some View {
        VStack(spacing: .gof.lg) {
            ZStack {
                // 긴급: 펄스 링
                if viewModel.riskLevel == .emergency {
                    Circle()
                        .fill(viewModel.riskLevel.signalColor.opacity(0.25))
                        .frame(width: 160, height: 160)
                        .scaleEffect(isPulsing ? 1.35 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                            value: isPulsing
                        )
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                isPulsing = true
                            }
                        }
                }

                // 신호등 원
                Circle()
                    .fill(viewModel.riskLevel.lightColor)
                    .frame(width: 160, height: 160)

                // 아이콘
                Image(systemName: viewModel.riskLevel.systemIcon)
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.riskLevel.signalColor)
            }

            VStack(spacing: .gof.sm) {
                Text(viewModel.riskLevel.displayName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(viewModel.riskLevel.signalColor)

                Text(viewModel.riskLevel.subtitle)
                    .font(.gof.body)
                    .foregroundColor(fgSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Weather Card

    private var weatherCard: some View {
        VStack(alignment: .leading, spacing: .gof.md) {
            HStack(spacing: .gof.xs) {
                Image(systemName: "sun.max.fill")
                    .font(.gof.icon)
                    .foregroundColor(Color(UIColor(red: 1.0, green: 0.741, blue: 0.0, alpha: 1)))

                Text("오늘의 날씨")
                    .font(.gof.subtitleMedium)
                    .foregroundColor(fgPrimary)
            }

            HStack(spacing: .gof.xxl) {
                weatherInfoItem(label: "기온", value: "\(viewModel.weather.temperature)°C")
                weatherInfoItem(label: "습도", value: "\(viewModel.weather.humidity)%")
                weatherInfoItem(label: "바람", value: "\(viewModel.weather.windSpeed)m/s")
                Spacer()
            }
        }
        .padding(.gof.md)
        .background(bgCard)
        .cornerRadius(.gof.radiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: .gof.radiusLarge)
                .stroke(cardBorder, lineWidth: .gof.borderThin)
        )
        .padding(.horizontal, .gof.md)
    }

    private func weatherInfoItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.gof.caption)
                .foregroundColor(fgSecondary)

            Text(value)
                .font(.gof.largeTitle)
                .foregroundColor(fgPrimary)
        }
    }

    // MARK: - Alert Message Card

    private func alertMessageCard(_ message: String) -> some View {
        HStack(alignment: .top, spacing: .gof.md) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(viewModel.riskLevel.signalColor)
                .padding(.top, 2)

            Text(message)
                .font(.gof.body)
                .foregroundColor(fgPrimary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.gof.md)
        .background(viewModel.riskLevel.lightColor)
        .cornerRadius(.gof.radiusLarge)
        .overlay(
            RoundedRectangle(cornerRadius: .gof.radiusLarge)
                .stroke(viewModel.riskLevel.signalColor.opacity(0.35), lineWidth: .gof.borderThin)
        )
        .padding(.horizontal, .gof.md)
    }

    // MARK: - Checklist

    private var checklistSection: some View {
        VStack(alignment: .leading, spacing: .gof.md) {
            Text("대응 체크리스트")
                .font(.gof.subtitle)
                .foregroundColor(fgPrimary)
                .padding(.horizontal, .gof.md)

            VStack(spacing: 0) {
                ForEach($viewModel.checklistItems) { $item in
                    checklistRow($item)

                    if item.id != viewModel.checklistItems.last?.id {
                        Divider()
                            .background(cardBorder)
                            .padding(.horizontal, .gof.md)
                    }
                }

                let allDone = !viewModel.checklistItems.isEmpty
                    && viewModel.checklistItems.allSatisfy(\.isCompleted)

                if allDone {
                    HStack(spacing: .gof.xs) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.gof.primaryGreen)
                        Text("체크리스트 완료 ✓")
                            .font(.gof.bodyMedium)
                            .foregroundColor(.gof.primaryGreen)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.gof.md)
                    .background(Color.gof.lightGreen.opacity(0.3))
                }
            }
            .background(bgCard)
            .cornerRadius(.gof.radiusLarge)
            .overlay(
                RoundedRectangle(cornerRadius: .gof.radiusLarge)
                    .stroke(cardBorder, lineWidth: .gof.borderThin)
            )
            .padding(.horizontal, .gof.md)
        }
    }

    private func checklistRow(_ item: Binding<ChecklistItem>) -> some View {
        Button {
            viewModel.toggleChecklist(id: item.wrappedValue.id)
        } label: {
            HStack(spacing: .gof.md) {
                Image(systemName: item.wrappedValue.isCompleted
                      ? "checkmark.square.fill"
                      : "square")
                    .font(.system(size: 20))
                    .foregroundColor(item.wrappedValue.isCompleted
                                     ? .gof.primaryGreen
                                     : .gof.borderDefault)

                Text(item.wrappedValue.text)
                    .font(.gof.body)
                    .foregroundColor(item.wrappedValue.isCompleted
                                     ? fgSecondary
                                     : fgPrimary)
                    .strikethrough(item.wrappedValue.isCompleted, color: fgSecondary)

                Spacer()
            }
            .padding(.gof.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Damage Report Button

    private var damageReportButton: some View {
        Button("피해 신고하기") {
            showDamageReport = true
        }
        .font(.gof.buttonLarge)
        .foregroundColor(.gof.white)
        .frame(height: .gof.heightMedium)
        .frame(maxWidth: .infinity)
        .background(Color.gof.error)
        .cornerRadius(.gof.radiusFull)
        .padding(.horizontal, .gof.md)
    }
}

// MARK: - Preview

#Preview("안전") {
    FarmStatusView()
}

#Preview("위험") {
    let vm = FarmStatusViewModel()
    let view = FarmStatusView()
    Task { await MainActor.run { vm.useMockDanger() } }
    return view
}

#Preview("긴급") {
    let vm = FarmStatusViewModel()
    let view = FarmStatusView()
    Task { await MainActor.run { vm.useMockEmergency() } }
    return view
}
