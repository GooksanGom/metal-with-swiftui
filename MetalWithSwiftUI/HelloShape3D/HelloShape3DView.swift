//
//  HelloShape3DView.swift
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/25/25.
//

import Metal
import MetalKit
import SwiftUI

enum Shape3DType: String, CaseIterable {
    // Add 3d shape types
    case cube
}

fileprivate struct ControlView: View {
    
    @Environment(HelloShape3DModel.self) private var content
    
    var body: some View {
        // replace EmptyView by your controls
        EmptyView()
    }
}

struct HelloShape3DView: View {
    
    @State private var content = HelloShape3DModel()
    
    @GestureState private var dragging: Bool = false
    @GestureState private var rotating: Bool = false
    
    var body: some View {
        // GeometryReader tells you the size of the view where it contains (using the `geometry` variable).
        GeometryReader { geometry in
            ZStack {
                MetalView(content.device,
                          onViewResized: content.onViewResized(_:_:),
                          onDraw: content.onDraw(_:))
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged { event in
                            let location = simd_float2( Float(event.location.x),
                                                       -Float(event.location.y))
                            let viewSize = simd_float2(Float(geometry.size.width),
                                                       Float(geometry.size.height))
                            let normalized = 2.0 * (location / min(viewSize.x, viewSize.y)) - 1.0
                            
                            content.onDragGesture(to: normalized, dragging ? .changed : .began)
                        }
                        .updating($dragging) { _, state, _ in
                            state = true
                        }
                        .onEnded { event in
                            let location = simd_float2( Float(event.location.x),
                                                       -Float(event.location.y))
                            let viewSize = simd_float2(Float(geometry.size.width),
                                                       Float(geometry.size.height))
                            let normalized = 2.0 * (location / min(viewSize.x, viewSize.y)) - 1.0
                            
                            content.onDragGesture(to: normalized, .ended)
                        }
                )
                .gesture(
                    RotateGesture()
                        .onChanged { event in
                            content.onRotateGesture(angle: Float(event.rotation.radians), rotating ? .changed : .began)
                        }
                        .updating($rotating) { _, state, _ in
                            state = true
                        }
                        .onEnded { event in
                            content.onRotateGesture(angle: Float(event.rotation.radians), .ended)
                        }
                )
                
                VStack {
                    Spacer()
                    ControlView()
                        .environment(content)
                }
                .padding()
            }
        }
    }
}

#Preview {
    HelloShape3DView()
}
