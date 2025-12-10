//
//  ManualTeamsView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

struct ManualTeamsView: View {
    let players: [Player]
    let gameState: GameState
    
    @State private var teamA: [Player] = []
    @State private var teamB: [Player] = []
    @State private var unassigned: [Player]
    @State private var navigationDestination: NavigationDestination?
    @State private var showAlert = false
    
    enum NavigationDestination: Hashable {
        case viewTeams
    }
    
    init(players: [Player], gameState: GameState) {
        self.players = players
        self.gameState = gameState
        _unassigned = State(initialValue: players)
    }
    
    var teamATotal: Int {
        TeamBalancer.getTeamTotal(team: teamA)
    }
    
    var teamBTotal: Int {
        TeamBalancer.getTeamTotal(team: teamB)
    }
    
    var difference: Int {
        abs(teamATotal - teamBTotal)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Pick Your Teams")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Tap A or B to assign players to teams")
                                .font(.system(size: 14))
                                .foregroundColor(Color(white: 0.67))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color.black)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(white: 0.2)),
                            alignment: .bottom
                        )
                        
                        // Unassigned Players
                        if !unassigned.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Unassigned Players (\(unassigned.count))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ForEach(unassigned) { player in
                                    UnassignedPlayerCard(
                                        player: player,
                                        onAddToTeamA: { addToTeamA(player) },
                                        onAddToTeamB: { addToTeamB(player) }
                                    )
                                }
                            }
                            .padding(16)
                        }
                        
                        // Team A
                        TeamSection(
                            teamName: "Team A",
                            teamColor: Color(red: 1.0, green: 0.42, blue: 0.42),
                            players: teamA,
                            total: teamATotal,
                            onRemove: { player in
                                removeFromTeamA(player)
                            }
                        )
                        
                        // Team B
                        TeamSection(
                            teamName: "Team B",
                            teamColor: Color(red: 0.31, green: 0.8, blue: 0.77),
                            players: teamB,
                            total: teamBTotal,
                            onRemove: { player in
                                removeFromTeamB(player)
                            }
                        )
                        
                        // Balance Info
                        if !teamA.isEmpty && !teamB.isEmpty {
                            VStack(spacing: 8) {
                                Text("Team Difference: \(difference)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                
                                if difference == 0 {
                                    Text("✓ Perfectly Balanced!")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                } else if difference > 5 {
                                    Text("⚠️ Teams may be unbalanced")
                                        .font(.system(size: 14))
                                        .foregroundColor(.orange)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(white: 0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Bottom Buttons
                VStack(spacing: 8) {
                    Button(action: handleViewTeams) {
                        Text("View Final Teams")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(6)
                    }
                    .disabled(!unassigned.isEmpty)
                    .opacity(unassigned.isEmpty ? 1.0 : 0.5)
                    
                    Button(action: { /* Navigate back */ }) {
                        Text("Back")
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
        .navigationTitle("Manual Teams")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(item: $navigationDestination) { destination in
            switch destination {
            case .viewTeams:
                TeamsView(
                    players: players,
                    gameState: gameState,
                    mode: .manual(teamA: teamA, teamB: teamB)
                )
            }
        }
        .alert("Incomplete Assignment", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please assign all players to teams first")
        }
    }
    
    private func addToTeamA(_ player: Player) {
        teamA.append(player)
        unassigned.removeAll { $0.id == player.id }
    }
    
    private func addToTeamB(_ player: Player) {
        teamB.append(player)
        unassigned.removeAll { $0.id == player.id }
    }
    
    private func removeFromTeamA(_ player: Player) {
        teamA.removeAll { $0.id == player.id }
        unassigned.append(player)
    }
    
    private func removeFromTeamB(_ player: Player) {
        teamB.removeAll { $0.id == player.id }
        unassigned.append(player)
    }
    
    private func handleViewTeams() {
        if !unassigned.isEmpty {
            showAlert = true
        } else {
            navigationDestination = .viewTeams
        }
    }
}

// MARK: - Unassigned Player Card
struct UnassignedPlayerCard: View {
    let player: Player
    let onAddToTeamA: () -> Void
    let onAddToTeamB: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("\(player.heightFormatted) | Total: \(player.totalRating)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.53))
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onAddToTeamA) {
                    Text("A")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color(red: 1.0, green: 0.42, blue: 0.42))
                        .clipShape(Circle())
                }
                
                Button(action: onAddToTeamB) {
                    Text("B")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color(red: 0.31, green: 0.8, blue: 0.77))
                        .clipShape(Circle())
                }
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

// MARK: - Team Section
struct TeamSection: View {
    let teamName: String
    let teamColor: Color
    let players: [Player]
    let total: Int
    let onRemove: (Player) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Team Header
            HStack {
                Text(teamName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(total)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(4)
            }
            .padding(12)
            .background(teamColor)
            
            // Team Players
            if players.isEmpty {
                Text("No players yet")
                    .font(.system(size: 14))
                    .foregroundColor(Color(white: 0.4))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(white: 0.1))
            } else {
                VStack(spacing: 0) {
                    ForEach(players) { player in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(player.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text("\(player.heightFormatted) | Total: \(player.totalRating)")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(white: 0.53))
                            }
                            
                            Spacer()
                            
                            Button(action: { onRemove(player) }) {
                                Text("×")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(12)
                        .background(Color(white: 0.1))
                        
                        if player.id != players.last?.id {
                            Divider()
                                .background(Color(white: 0.2))
                        }
                    }
                }
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        ManualTeamsView(
            players: [
                Player(name: "John Doe", scoring: 4, defense: 3, playmaking: 4, athleticism: 5, intangibles: 3, height: 74),
                Player(name: "Jane Smith", scoring: 3, defense: 5, playmaking: 3, athleticism: 4, intangibles: 4, height: 70)
            ],
            gameState: GameState(courtName: "Test Court", location: "Test Location")
        )
    }
}
