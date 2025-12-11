//
//  HomeView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var navigateToCreateGame = false
    @State private var showingPlayerLibrary = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Centered menu section
                    VStack(spacing: 0) {
                        // Header with border
                        VStack(spacing: 8) {
                            Image("Logo")
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color.secondary.opacity(0.3)),
                            alignment: .bottom
                        )
                        
                        // Spacer between header and button
                        Spacer()
                            .frame(height: 24)
                        
                        // Create game button
                        NavigationLink(destination: CreateGameView()) {
                            Text("Create a New Game")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer()
                            .frame(height: 16)
                        
                        // Player Library button
                        Button {
                            showingPlayerLibrary = true
                        } label: {
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("Player Library")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    
                    Spacer()
                    
                    // How it works section (left-aligned)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("How it works")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("1. Create a game session with court details")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            
                            Text("2. Add players and rate their skills (1-5)")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            
                            Text("3. Auto-balance teams fairly")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                            
                            Text("4. Check out your balanced teams")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 32)
                    .padding(.bottom, 24)
                    
                    Spacer()
                    
                    // Footer section
                    VStack(spacing: 4) {
                        Text("© 2025 NextAllis Tech")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                            Text("Version \(version) (Build \(build))")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingPlayerLibrary) {
                PlayerLibraryView()
            }
        }
    }
}

#Preview {
    HomeView()
}
