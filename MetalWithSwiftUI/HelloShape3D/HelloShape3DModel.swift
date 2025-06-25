//
//  HelloShape3DModel.swift
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/25/25.
//

import Metal
import MetalKit
import SwiftUI

@Observable
final class HelloShape3DModel {
    
    let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    
    private var startTime: CFTimeInterval = CACurrentMediaTime()
    private var timeSinceStart: Float = 0.0
    
    init() {
        
        let device = MTLCreateSystemDefaultDevice()!
        let commandQueue = device.makeCommandQueue()!
        let library = device.makeDefaultLibrary()!
        
        // initialize your renderers object here
        
        self.device = device
        self.commandQueue = commandQueue
        
        // initialize your properties here
    }
    
    func onViewResized(_ view: MTKView, _ size: CGSize) {
        // update your camera here
    }
    
    private func update(_ timeElapsed: Float) {
        // update your renderers here
    }
    
    func onDraw(_ view: MTKView) {
        
        let currentTime = CACurrentMediaTime()
        let timeElapsed = Float(currentTime - startTime)
        timeSinceStart += timeElapsed
        update(timeElapsed)
        startTime = currentTime
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
        let drawable = view.currentDrawable,
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        
        // invoke draw calls with your renderers here
        
        encoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
