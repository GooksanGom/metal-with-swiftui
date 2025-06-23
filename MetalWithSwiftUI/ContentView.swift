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
    private let commandQueue: MTLCommandQueue
    private let triangleRenderer: TriangleRenderer
    
    private var startTime: CFTimeInterval = CACurrentMediaTime()
    
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
        self.triangleRenderer.viewAspectRatio = Float(size.width / size.height)
    }
    
    func onDraw(_ view: MTKView) {
        
        let rotationPerSecond: Float = 0.33
        let currentTime = CACurrentMediaTime()
        let elapsedTime = currentTime - startTime
        let angle: Float = rotationPerSecond * Float(elapsedTime) * 2.0 * .pi
        
        self.triangleRenderer.transform = .rotate(angle: angle, along: .init(0, 0, 1))
        
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
