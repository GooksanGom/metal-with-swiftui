//
//  ContentView.swift
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/23/25.
//

import Metal
import MetalKit
import SwiftUI

@Observable
final class ContentModel {
    
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let triangleRenderer: TriangleRenderer
    
    init() {
        
        let device = MTLCreateSystemDefaultDevice()!
        let commandQueue = device.makeCommandQueue()!
        let library = device.makeDefaultLibrary()!
        
        let triangleRenderer = TriangleRenderer(device, library)
        
        self.device = device
        self.commandQueue = commandQueue
        self.triangleRenderer = triangleRenderer
    }
    
    func onViewResized(_ view: MTKView, _ size: CGSize) {
        
    }
    
    func onDraw(_ view: MTKView) {
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        triangleRenderer.draw(encoder)
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct ContentView: View {
    
    @State private var content = ContentModel()
    
    var body: some View {
        MetalView(content.device,
                  onViewResized: content.onViewResized(_:_:),
                  onDraw: content.onDraw(_:))
    }
}

#Preview {
    ContentView()
}
