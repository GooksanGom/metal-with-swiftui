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
    
    var body: some View {
        ZStack {
            MetalView(content.device,
                      onViewResized: content.onViewResized(_:_:),
                      onDraw: content.onDraw(_:))
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                ControlView()
                    .environment(content)
            }
            .padding()
        }
    }
}

#Preview {
    HelloShape3DView()
}
