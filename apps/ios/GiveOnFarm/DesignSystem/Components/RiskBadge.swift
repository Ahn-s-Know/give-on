// RiskBadge.swift
// Give On Farm — 위험도 배지 & 신호등 컴포넌트

import SwiftUI

// MARK: - RiskLevel

enum RiskLevel: String, CaseIterable, Comparable {
    case safe = "safe"
    case caution = "caution"
    case danger = "danger"
    case emergency = "emergency"

    // MARK: Comparable
    private var order: Int {
        switch self {
        case .safe:      return 0
        case .caution:   return 1
        case .danger:    return 2
        case .emergency: return 3
        }
    }
    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        lhs.order < rhs.order
    }

    // MARK: Display
    var label: String {
        switch self {
        case .safe:      return "안전"
        case .caution:   return "주의"
        case .danger:    return "위험"
        case .emergency: return "긴급"
        }
    }

    var color: Color {
        switch self {
        case .safe:      return Color(red: 0.13, green: 0.64, blue: 0.32)   // green
        case .caution:   return Color(red: 0.92, green: 0.70, blue: 0.04)   // yellow
        case .danger:    return Color(red: 0.98, green: 0.46, blue: 0.09)   // orange
        case .emergency: return Color(red: 0.94, green: 0.21, blue: 0.26)   // red
        }
    }

    var emoji: String {
        switch self {
        case .safe:      return "✅"
        case .caution:   return "⚠️"
        case .danger:    return "⚠️"
        case .emergency: return "🚨"
        }
    }

    static func from(_ string: String) -> RiskLevel {
        RiskLevel(rawValue: string) ?? .safe
    }
}

// MARK: - RiskSignalView (신호등)

struct RiskSignalView: View {
    let level: RiskLevel

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(level.color.opacity(0.15))
                    .frame(width: 120, height: 120)

                Circle()
                    .fill(level.color)
                    .frame(width: 100, height: 100)
                    .shadow(color: level.color.opacity(0.5), radius: 16, x: 0, y: 4)

                Text(level.emoji)
                    .font(.system(size: 40))
            }

            Text(level.label)
                .font(.title2.bold())
                .foregroundColor(level.color)

            Text("오늘 내 농장 위험도")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - RiskBadge (소형 배지)

struct RiskBadge: View {
    let level: RiskLevel
    var compact: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(level.color)
                .frame(width: compact ? 8 : 10, height: compact ? 8 : 10)
            Text(level.label)
                .font(compact ? .caption2.bold() : .caption.bold())
                .foregroundColor(level.color)
        }
        .padding(.horizontal, compact ? 8 : 10)
        .padding(.vertical, compact ? 3 : 5)
        .background(level.color.opacity(0.12))
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        ForEach(RiskLevel.allCases, id: \.rawValue) { level in
            HStack(spacing: 16) {
                RiskSignalView(level: level)
                    .frame(width: 140)
                VStack(alignment: .leading, spacing: 8) {
                    RiskBadge(level: level)
                    RiskBadge(level: level, compact: true)
                }
            }
        }
    }
    .padding()
}
