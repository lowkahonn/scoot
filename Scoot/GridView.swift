import Cocoa

class GridView: NSView {

    weak var viewController: ViewController!

    func redraw() {
        setNeedsDisplay(bounds)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard viewController.isDisplayingGrid else {
            return
        }

        guard let grid = viewController.grid else {
            return
        }

        guard let ctx = NSGraphicsContext.current else {
            return
        }

        let cellSize = grid.cellSize

        ctx.cgContext.setStrokeColor(NSColor.systemTeal.withAlphaComponent(0.04).cgColor)
        ctx.cgContext.setLineWidth(2)

        for x in stride(from: 0.0, to: grid.size.width, by: cellSize.width) {
            ctx.cgContext.move(to: CGPoint(x: x, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: x, y: grid.size.height))
        }

        for y in stride(from: 0.0, to: grid.size.height, by: cellSize.height) {
            ctx.cgContext.move(to: CGPoint(x: 0, y: y))
            ctx.cgContext.addLine(to: CGPoint(x: grid.size.width, y: y))
        }

        ctx.cgContext.drawPath(using: .stroke)

        let font = NSFont.systemFont(ofSize: 16, weight: .medium)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attrs: [NSAttributedString.Key: Any]  = [
          .font: font,
          .foregroundColor: NSColor.systemTeal.withAlphaComponent(0.5),
          .paragraphStyle: paragraphStyle
        ]

        for (index, cellRect) in grid.rects.enumerated() {
            let text = grid.data(atIndex: index)

            let boundingRect = text.boundingRect(
                with: cellRect.size,
                options: .usesLineFragmentOrigin,
                attributes: attrs
            )

            let textHeight = boundingRect.height

            text.draw(
                with: CGRect(
                    origin: CGPoint(
                        x: cellRect.origin.x,
                        y: cellRect.origin.y - textHeight
                    ),
                    size: cellRect.size
                ),
                options: .usesLineFragmentOrigin,
                attributes: attrs,
                context: nil
            )

        }

    }
}
