//
//  LaunchScreenView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct LaunchScreenView: View {
    var onDismiss: () -> Void
    
    @State private var animateGradient = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var bounceAnimation = false
    
    var body: some View {
        ZStack {
            // Animated gradient background with darker grayscale colors
            LinearGradient(
                colors: [Color.black, Color.black],
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            VStack(spacing: 24) {
                // Basketball Icon with glow
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .blur(radius: 20)
                    
                    // Basketball icon
                    Image(systemName: "basketball.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .offset(y: bounceAnimation ? -10 : 0)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                
                // App Name
                Text("RUN IT BACK")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(logoOpacity)
            }
            .onAppear {
                // Animate logo entrance
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
                
                // Bounce animation for basketball with proper delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                        bounceAnimation = true
                    }
                }
            }
        }
        .onAppear {
            // Auto-dismiss after 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onDismiss()
            }
        }
    }
}

#Preview {
    LaunchScreenView(onDismiss: {})
}
