//
//  RunItBackApp.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

@main
struct RunItBackApp: App {
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main view (always rendered underneath)
                HomeView()
                    .zIndex(0)
                
                // Launch screen overlay with slide-up transition
                if isLoading {
                    LaunchScreenView(onDismiss: {
                        withAnimation(.easeOut(duration: 0.6)) {
                            isLoading = false
                        }
                    })
                    .transition(.asymmetric(
                        insertion: .identity,
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .zIndex(1)
                }
            }
            .animation(.easeOut(duration: 0.6), value: isLoading)
        }
        .modelContainer(for: Player.self)
    }
}
