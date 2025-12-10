//
//  AddPlayersView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI
import SwiftData

struct AddPlayersView: View {
    @Environment(\.modelContext) private var modelContext
    
    let gameState: GameState
    
    @State private var players: [Player] = []
    @State private var playerName: String = ""
    @State private var scoring: Int = 3
    @State private var defense: Int = 3
    @State private var playmaking: Int = 3
    @State private var athleticism: Int = 3
    @State private var intangibles: Int = 3
    @State private var heightFeet: Int = 6
    @State private var heightInches: Int = 0
    @State private var navigationDestination: NavigationDestination?
    @State private var showAlert = false
    @State private var showingPlayerLibrary = false
    
    enum NavigationDestination: Hashable {
        case autoBalance
        case manualPick
    }
    
    var totalHeight: Int {
        heightFeet * 12 + heightInches
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        // Import from Library Button
                        Button {
                            showingPlayerLibrary = true
                        } label: {
                            HStack {
                                Image(systemName: "person.2.fill")
                                Text("Import from Library")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.cyan)
                            .cornerRadius(8)
                        }
                        
                        // Add Player Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Add Player")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            PlayerCustomizationView(
                                name: $playerName,
                                scoring: $scoring,
                                defense: $defense,
                                playmaking: $playmaking,
                                athleticism: $athleticism,
                                intangibles: $intangibles,
                                heightFeet: $heightFeet,
                                heightInches: $heightInches,
                                showNameField: true,
                                showTotalRating: false
                            )
                            
                            Button(action: addPlayer) {
                                Text("Add Player")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(16)
                        .background(Color(white: 0.1))
                        .cornerRadius(12)
                        
                        // Players List
                        if !players.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Players (\(players.count))")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ForEach(players) { player in
                                    PlayerCardView(player: player, onDelete: {
                                        deletePlayer(player)
                                    })
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                
                // Bottom Buttons
                if players.count >= 2 {
                    VStack(spacing: 8) {
                        Button(action: { navigationDestination = .autoBalance }) {
                            Text("Auto Balance Teams")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.white)
                                .cornerRadius(6)
                        }
                        
                        Button(action: { navigationDestination = .manualPick }) {
                            Text("Pick Teams Manually")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(white: 0.1))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color(white: 0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding(16)
                    .background(Color.black)
                }
            }
        }
        .navigationTitle("Add Players")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(item: $navigationDestination) { destination in
            switch destination {
            case .autoBalance:
                TeamsView(
                    players: players,
                    gameState: gameState,
                    mode: .autoBalance
                )
            case .manualPick:
                ManualTeamsView(
                    players: players,
                    gameState: gameState
                )
            }
        }
        .sheet(isPresented: $showingPlayerLibrary) {
            PlayerLibrarySelectionView(players: $players)
        }
    }
    
    private func addPlayer() {
        guard !playerName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let newPlayer = Player(
            name: playerName,
            scoring: scoring,
            defense: defense,
            playmaking: playmaking,
            athleticism: athleticism,
            intangibles: intangibles,
            height: totalHeight,
            isSaved: false
        )
        
        players.append(newPlayer)
        
        // Reset form
        playerName = ""
        scoring = 3
        defense = 3
        playmaking = 3
        athleticism = 3
        intangibles = 3
        heightFeet = 6
        heightInches = 0
    }
    
    private func deletePlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
    }
}

// MARK: - Player Card Component
struct PlayerCardView: View {
    let player: Player
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    Text("SC:\(player.scoring)")
                    Text("DF:\(player.defense)")
                    Text("PM:\(player.playmaking)")
                    Text("AT:\(player.athleticism)")
                    Text("IN:\(player.intangibles)")
                    Text(player.heightFormatted)
                }
                .font(.system(size: 11))
                .foregroundColor(Color(white: 0.6))
            }
            
            Spacer()
            
            Text("\(player.totalRating)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(white: 0.2))
                .cornerRadius(4)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(12)
        .background(Color(white: 0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        AddPlayersView(gameState: GameState(courtName: "Test Court", location: "Test Location"))
    }
}
