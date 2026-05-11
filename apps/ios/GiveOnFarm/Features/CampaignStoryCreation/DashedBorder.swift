import SwiftUI

struct DashedBorder: Shape {
    let dashLength: CGFloat
    let gapLength: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cornerRadius: CGFloat = 12

        // Top-left corner
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        addDashedLine(
            to: CGPoint(x: rect.maxX - cornerRadius, y: 0),
            in: &path
        )

        // Top-right corner
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: cornerRadius),
            control1: CGPoint(x: rect.maxX, y: 0),
            control2: CGPoint(x: rect.maxX, y: 0)
        )

        addDashedLine(
            to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius),
            in: &path
        )

        // Bottom-right corner
        path.addCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.maxY),
            control2: CGPoint(x: rect.maxX, y: rect.maxY)
        )

        addDashedLine(
            to: CGPoint(x: cornerRadius, y: rect.maxY),
            in: &path
        )

        // Bottom-left corner
        path.addCurve(
            to: CGPoint(x: 0, y: rect.maxY - cornerRadius),
            control1: CGPoint(x: 0, y: rect.maxY),
            control2: CGPoint(x: 0, y: rect.maxY)
        )

        addDashedLine(
            to: CGPoint(x: 0, y: cornerRadius),
            in: &path
        )

        // Top-left corner
        path.addCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control1: CGPoint(x: 0, y: 0),
            control2: CGPoint(x: 0, y: 0)
        )

        return path
    }

    private func addDashedLine(to point: CGPoint, in path: inout Path) {
        let currentPoint = path.currentPoint ?? .zero
        let distance = sqrt(pow(point.x - currentPoint.x, 2) + pow(point.y - currentPoint.y, 2))
        let steps = Int(distance / (dashLength + gapLength))

        let dirX = (point.x - currentPoint.x) / distance
        let dirY = (point.y - currentPoint.y) / distance

        var currentPos = currentPoint

        for _ in 0..<steps {
            let nextPos = CGPoint(
                x: currentPos.x + dirX * dashLength,
                y: currentPos.y + dirY * dashLength
            )
            path.addLine(to: nextPos)
            currentPos = CGPoint(
                x: nextPos.x + dirX * gapLength,
                y: nextPos.y + dirY * gapLength
            )
        }

        path.addLine(to: point)
    }
}

extension View {
    func dashedBorder(color: Color, width: CGFloat = 2) -> some View {
        overlay(
            DashedBorder(dashLength: 6, gapLength: 4)
                .stroke(color, lineWidth: width)
        )
    }
}
