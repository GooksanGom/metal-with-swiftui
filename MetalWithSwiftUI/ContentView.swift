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
    
    var brightness: Float = 1.0
    
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
    
    private func update(_ timeElapsed: Float) {
        
        let rotationPerSecond: Float = 0.33
        let angle = rotationPerSecond * timeElapsed * 2.0 * .pi
        
        self.triangleRenderer.transform = .rotate(angle: angle, along: .init(0, 0, 1))
        
        self.triangleRenderer.brightness = self.brightness
    }
    
    func onDraw(_ view: MTKView) {
        
        let currentTime = CACurrentMediaTime()
        let timeElapsed = Float(currentTime - startTime)
        update(timeElapsed)
        
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
        ZStack {
            MetalView(content.device,
                      onViewResized: content.onViewResized(_:_:),
                      onDraw: content.onDraw(_:))
            .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Spacer()
                Text("Brightness: \(content.brightness, format: .percent)")
                Slider(value: $content.brightness, in: 0.0...1.0)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
