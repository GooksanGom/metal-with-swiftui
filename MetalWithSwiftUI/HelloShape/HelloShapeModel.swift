//
//  HelloShapeModel.swift
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/24/25.
//

import Metal
import MetalKit
import SwiftUI

@Observable
final class HelloShapeModel {
    
    let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let triangleRenderer: TriangleRenderer
    private let squareRenderer: SquareRenderer
    
    private var startTime: CFTimeInterval = CACurrentMediaTime()
    
    var rotationPerSecond: Float = 0.33
    var rotationAngle: Float = 0.0
    var brightness: Float = 1.0
    
    var shapeType: ShapeType = .triangle
    
    init() {
        
        let device = MTLCreateSystemDefaultDevice()!
        let commandQueue = device.makeCommandQueue()!
        let library = device.makeDefaultLibrary()!
        
        let triangleRenderer = TriangleRenderer(device, library)
        let squareRenderer = SquareRenderer(device, library)
        
        self.device = device
        self.commandQueue = commandQueue
        self.triangleRenderer = triangleRenderer
        self.squareRenderer = squareRenderer
    }
    
    func onViewResized(_ view: MTKView, _ size: CGSize) {
        self.triangleRenderer.viewAspectRatio = Float(size.width / size.height)
        self.squareRenderer.viewAspectRatio = Float(size.width / size.height)
    }
    
    private func update(_ timeElapsed: Float) {
        
        let deltaAngle = rotationPerSecond * timeElapsed * 2.0 * .pi
        rotationAngle += deltaAngle
        let rotation = simd_float4x4.rotate(angle: rotationAngle, along: .init(0, 0, 1))
        self.triangleRenderer.transform = rotation
        self.squareRenderer.transform = rotation
        
        self.triangleRenderer.brightness = self.brightness
        self.squareRenderer.brightness = self.brightness
    }
    
    func onDraw(_ view: MTKView) {
        
        let currentTime = CACurrentMediaTime()
        let timeElapsed = Float(currentTime - startTime)
        update(timeElapsed)
        startTime = currentTime
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        switch shapeType {
        case .triangle: triangleRenderer.draw(encoder)
        case .square:   squareRenderer.draw(encoder)
        case .circle:   break
        }
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
