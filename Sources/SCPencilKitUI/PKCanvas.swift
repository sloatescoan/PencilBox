import SwiftUI
import PencilKit

public struct PKCanvas: UIViewRepresentable {
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PKCanvas

        init(parent: PKCanvas) {
            self.parent = parent
        }

        public func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            print("drawingDidChange: \(canvasView.drawing)")
            parent.drawing = canvasView.drawing
        }

        public func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
            print("didFinishRendering")
        }

        public func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            print("didBeginUsingTool")
        }

        public func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
            print("didEndUsingTool")
        }

    }

    var tool: PKInkingTool
    var isRuleActive: Bool
    @Binding var drawing: PKDrawing

    func makeUIView(context: Context) -> PKCanvasView {
        let view = PKCanvasView()
        view.delegate = context.coordinator
        view.tool = tool
        view.isRulerActive = isRuleActive
        view.drawing = drawing

        return view
    }

    func updateUIView(_ view: PKCanvasView, context: Context) {
        context.coordinator.parent = self
        view.tool = tool
        view.drawing = drawing
        view.isRulerActive = isRuleActive
        view.drawingPolicy = .anyInput
    }

}

#Preview {
    PKCanvas(
        tool: PKInkingTool(.pen, color: .black, width: 10),
        isRuleActive: true,
        drawing: .constant(PKDrawing())
    )
}
