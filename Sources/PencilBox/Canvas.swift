//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sloan on 8/10/24.
//

import SwiftUI
import PencilKit

private struct CanvasDemo: View {
    @State var tool = PKInkingTool(.pen, color: .red, width: 10)
    @State var isRulerActive = false
    @State var drawing1 = PKDrawing()
    @State var drawing2 = PKDrawing()

    var body: some View {
        ZStack {
            PKCanvas(
                tool: tool,
                isRuleActive: isRulerActive,
                drawing: $drawing1
            )

            VStack {
                Spacer()
                HStack {
                    Button {
                        tool.color = .red
                    } label: {
                        Text("Red")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        tool.color = .blue
                    } label: {
                        Text("Blue")
                    }
                    .buttonStyle(.borderedProminent)
                }

                HStack {
                    Button {
                        isRulerActive.toggle()
                    } label: {
                        Text(isRulerActive ? "Hide ruler" : "Show ruler")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        let tmp = drawing1
                        drawing1 = drawing2
                        drawing2 = tmp
                    } label: {
                        Text("Swap drawing")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onChange(of: drawing1) { newValue in
                print("onChange: \(drawing1)")
            }
        }
    }
}

#Preview {
    CanvasDemo()
}
