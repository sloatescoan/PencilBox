import SwiftUI
import PencilKit

public struct PKCanvas: UIViewRepresentable {
    public var tool: PKInkingTool
    public var isRuleActive: Bool
    @Binding public var drawing: PKDrawing

    public var drawingDidChange: () -> Void
    public var didFinishRendering: () -> Void
    public var didBeginUsingTool: () -> Void
    public var didEndUsingTool: () -> Void


    public init(
        tool: PKInkingTool,
        isRuleActive: Bool,
        drawing: Binding<PKDrawing>,
        drawingDidChange: @escaping () -> Void = {},
        didFinishRendering: @escaping () -> Void = {},
        didBeginUsingTool: @escaping () -> Void = {},
        didEndUsingTool: @escaping () -> Void = {}
    ) {
        self.tool = tool
        self.isRuleActive = isRuleActive
        self._drawing = drawing

        self.drawingDidChange = drawingDidChange
        self.didFinishRendering = didFinishRendering
        self.didBeginUsingTool = didBeginUsingTool
        self.didEndUsingTool = didEndUsingTool
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PKCanvas

        init(parent: PKCanvas) {
            self.parent = parent
        }

        public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // TODO: We should be thoughtful about what the user might need here
            parent.drawing = canvasView.drawing
            parent.drawingDidChange()
        }

        public func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
            // TODO: We should be thoughtful about what the user might need here
            parent.didFinishRendering()
        }

        public func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            // TODO: We should be thoughtful about what the user might need here
            parent.didBeginUsingTool()
        }

        public func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            // TODO: We should be thoughtful about what the user might need here
            parent.didFinishRendering()
        }

    }

    public func makeUIView(context: Context) -> PKCanvasView {
        let view = PKCanvasView()
        view.delegate = context.coordinator
        view.tool = tool
        view.isRulerActive = isRuleActive
        view.drawing = drawing
        view.isOpaque = false
        view.backgroundColor = .clear

        return view
    }

    public func updateUIView(_ view: PKCanvasView, context: Context) {
        context.coordinator.parent = self
        view.tool = tool
        view.drawing = drawing
        view.isRulerActive = isRuleActive
        view.drawingPolicy = .anyInput
    }

    public func onToolDown(_ callback: @escaping () -> Void) -> PKCanvas {
        var canvas = self
        canvas.didBeginUsingTool = callback
        return canvas
    }

    public func onToolUp(_ callback: @escaping () -> Void) -> PKCanvas {
        var canvas = self
        canvas.didEndUsingTool = callback
        return canvas
    }
}

#Preview {
    PKCanvas(
        tool: PKInkingTool(.pen, color: .black, width: 10),
        isRuleActive: true,
        drawing: .constant(PKDrawing())
    )
}
