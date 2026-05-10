import SwiftUI

/// GiveOnFarm 앱의 유용한 View Extension들

extension View {
    /// 점선 테두리를 추가합니다
    func dashedBorder(color: Color, width: CGFloat, cornerRadius: CGFloat = 12, dashPattern: [CGFloat] = [5, 5]) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(style: StrokeStyle(lineWidth: width, dash: dashPattern))
                .foregroundColor(color)
        )
    }
}
