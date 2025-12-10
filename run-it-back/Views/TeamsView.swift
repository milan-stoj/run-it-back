//
//  TeamsView.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import SwiftUI

enum TeamDisplayMode {
    case autoBalance
    case manual(teamA: [Player], teamB: [Player])
}

struct TeamsView: View {
    let players: [Player]
    let gameState: GameState
    let mode: TeamDisplayMode
    
    var teamA: [Player] {
        switch mode {
        case .autoBalance:
            return TeamBalancer.balanceTeams(players: players).teamA
        case .manual(let teamA, _):
            return teamA
        }
    }
    
    var teamB: [Player] {
        switch mode {
        case .autoBalance:
            return TeamBalancer.balanceTeams(players: players).teamB
        case .manual(_, let teamB):
            return teamB
        }
    }
    
    var teamATotal: Int {
        TeamBalancer.getTeamTotal(team: teamA)
    }
    
    var teamBTotal: Int {
        TeamBalancer.getTeamTotal(team: teamB)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Teams Display
                    HStack(alignment: .top, spacing: 12) {
                        // Team A
                        TeamColumn(
                            teamName: "Team A",
                            teamColor: Color(red: 1.0, green: 0.42, blue: 0.42),
                            players: teamA,
                            total: teamATotal
                        )
                        
                        // Team B
                        TeamColumn(
                            teamName: "Team B",
                            teamColor: Color(red: 0.31, green: 0.8, blue: 0.77),
                            players: teamB,
                            total: teamBTotal
                        )
                    }
                    .padding(16)
                    
                    // Game Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Game Details")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        VStack(spacing: 8) {
                            InfoRow(label: "Court", value: gameState.courtName)
                            InfoRow(label: "Location", value: gameState.location)
                            InfoRow(label: "Date", value: formatDate(gameState.date))
                            InfoRow(label: "Type", value: gameState.gameType.rawValue)
                        }
                    }
                    .padding(16)
                    .background(Color(white: 0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(white: 0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .navigationTitle("Teams")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Team Column
struct TeamColumn: View {
    let teamName: String
    let teamColor: Color
    let players: [Player]
    let total: Int
    
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
                Text("No players")
                    .font(.system(size: 14))
                    .foregroundColor(Color(white: 0.4))
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(white: 0.1))
            } else {
                VStack(spacing: 0) {
                    ForEach(players) { player in
                        PlayerRowView(player: player)
                        
                        if player.id != players.last?.id {
                            Divider()
                                .background(Color(white: 0.2))
                        }
                    }
                }
                .background(Color(white: 0.1))
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(white: 0.2), lineWidth: 1)
        )
    }
}

// MARK: - Player Row
struct PlayerRowView: View {
    let player: Player
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(player.heightFormatted)
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.53))
            }
            
            Spacer()
            
            Text("\(player.totalRating)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(white: 0.2))
                .cornerRadius(4)
        }
        .padding(12)
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.67))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NavigationStack {
        TeamsView(
            players: [
                Player(name: "John Doe", scoring: 4, defense: 3, playmaking: 4, athleticism: 5, intangibles: 3, height: 74),
                Player(name: "Jane Smith", scoring: 3, defense: 5, playmaking: 3, athleticism: 4, intangibles: 4, height: 70),
                Player(name: "Bob Johnson", scoring: 5, defense: 2, playmaking: 3, athleticism: 3, intangibles: 5, height: 78),
                Player(name: "Alice Williams", scoring: 2, defense: 4, playmaking: 5, athleticism: 3, intangibles: 3, height: 68)
            ],
            gameState: GameState(courtName: "Central Park", location: "Manhattan, NY"),
            mode: .autoBalance
        )
    }
}
