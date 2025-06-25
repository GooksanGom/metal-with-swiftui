//
//  ContentView.swift
//  MetalWithSwiftUI
//
//  Created by CurvSurf-SGKim on 6/23/25.
//

import Metal
import MetalKit
import SwiftUI

enum Content: String, CaseIterable {
    case helloShape2D = "Hello Shape 2D"
}

struct ContentView: View {
    
    @State private var selectedContent: Content?
    
    var body: some View {
        NavigationSplitView {
            List(Content.allCases, id: \.self, selection: $selectedContent) { content in
                Text(content.rawValue)
            }
            .navigationTitle("Content")
        } detail: {
            if let selectedContent {
                switch selectedContent {
                case .helloShape2D: HelloShape2DView()
                }
            } else {
                Text("Select content from the left panel.")
            }
        }
    }
}

#Preview {
    ContentView()
}
