//
//  CreateGameView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct CreateGameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var gameState = GameState()
    @State private var navigationDestination: NavigationDestination?
    @State private var showAlert = false
    
    enum NavigationDestination: Hashable {
        case addPlayers
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Court Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Court / Gym Name")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("e.g., Central Park Court", text: $gameState.courtName)
                            .padding()
                            .background(Color(white: 0.1))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.2), lineWidth: 1)
                            )
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Location")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        TextField("e.g., Manhattan, NY", text: $gameState.location)
                            .padding()
                            .background(Color(white: 0.1))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.2), lineWidth: 1)
                            )
                    }
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date & Time")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        DatePicker("", selection: $gameState.date)
                            .datePickerStyle(.compact)
                            .colorScheme(.dark)
                            .padding()
                            .background(Color(white: 0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.2), lineWidth: 1)
                            )
                    }
                    
                    // Game Type
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Game Type")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            ForEach(GameType.allCases, id: \.self) { type in
                                Button(action: {
                                    gameState.gameType = type
                                }) {
                                    Text(type.rawValue)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(gameState.gameType == type ? .black : .white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(gameState.gameType == type ? Color.white : Color(white: 0.1))
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(white: 0.2), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    
                    // Continue Button
                    Button(action: {
                        if gameState.isValid {
                            navigationDestination = .addPlayers
                        } else {
                            showAlert = true
                        }
                    }) {
                        Text("Continue to Add Players")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
                .padding(24)
            }
        }
        .navigationTitle("Create Game")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(item: $navigationDestination) { destination in
            switch destination {
            case .addPlayers:
                AddPlayersView(gameState: gameState)
            }
        }
        .alert("Missing Information", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in all fields")
        }
    }
}

#Preview {
    NavigationStack {
        CreateGameView()
    }
}
