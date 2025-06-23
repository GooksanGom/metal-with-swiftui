//
//  Shader.metal
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/23/25.
//

#include <metal_stdlib>

using namespace metal;

namespace hello_triangle {
    
    struct Vertex {
        float2 position [[ attribute(0) ]];
        float3 color    [[ attribute(1) ]];
    };
    
    struct VertexOut {
        float4 position [[ position ]];
        float3 color;
    };
    
    vertex VertexOut vertex_function(Vertex in [[ stage_in ]],
                                     constant float4x4 &transform [[ buffer(1) ]]) {
        
        VertexOut out;
        out.position = transform * float4(in.position, 0, 1);
        out.color = in.color;
        
        return out;
    }
    
    fragment float4 fragment_function(VertexOut in [[ stage_in ]],
                                      constant float &brightness [[ buffer(1) ]]) {
        auto final_color = in.color * brightness;
        return float4(final_color, 1);
    }
}
