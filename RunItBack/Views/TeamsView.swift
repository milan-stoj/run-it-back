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
    
    var teamDifference: Int {
        teamATotal - teamBTotal
    }
    
    var teamAAdvantage: String {
        if teamDifference > 0 {
            return "+\(teamDifference)"
        } else if teamDifference < 0 {
            return "\(teamDifference)"
        } else {
            return "Even"
        }
    }
    
    var teamBAdvantage: String {
        if teamDifference < 0 {
            return "+\(abs(teamDifference))"
        } else if teamDifference > 0 {
            return "-\(teamDifference)"
        } else {
            return "Even"
        }
    }
    
    var teamAColor: Color {
        if teamATotal > teamBTotal {
            return Color(red: 0.31, green: 0.8, blue: 0.77)
        } else if teamBTotal > teamATotal {
            return Color(red: 1.0, green: 0.42, blue: 0.42)
        } else {
            return Color.accentColor.opacity(0.7)
        }
    }
    
    var teamBColor: Color {
        if teamBTotal > teamATotal {
            return Color(red: 0.31, green: 0.8, blue: 0.77)
        } else if teamATotal > teamBTotal {
            return Color(red: 1.0, green: 0.42, blue: 0.42)
        } else {
            return Color.accentColor.opacity(0.7)
        }
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Teams Display
                    HStack(alignment: .top, spacing: 12) {
                        // Team A
                        TeamColumn(
                            teamName: "Team A",
                            teamColor: teamAColor,
                            players: teamA,
                            total: teamATotal,
                            advantage: teamAAdvantage
                        )
                        
                        // Team B
                        TeamColumn(
                            teamName: "Team B",
                            teamColor: teamBColor,
                            players: teamB,
                            total: teamBTotal,
                            advantage: teamBAdvantage
                        )
                    }
                    .padding(16)
                    
                    // Game Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Game Details")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                        
                        VStack(spacing: 8) {
                            InfoRow(label: "Court", value: gameState.courtName)
                            InfoRow(label: "Location", value: gameState.location)
                            InfoRow(label: "Date", value: formatDate(gameState.date))
                            InfoRow(label: "Type", value: gameState.gameType.rawValue)
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .navigationTitle("Teams")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
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
    let advantage: String
    
    var advantageColor: Color {
        .primary.opacity(0.7)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Team Header
            VStack(spacing: 4) {
                HStack {
                    Text(teamName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text(advantage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(12)
            .background(teamColor)
            
            // Team Players
            if players.isEmpty {
                Text("No players")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(Color(UIColor.secondarySystemBackground))
            } else {
                VStack(spacing: 0) {
                    ForEach(players) { player in
                        PlayerRowView(player: player)
                        
                        if player.id != players.last?.id {
                            Divider()
                                .background(Color.secondary.opacity(0.2))
                        }
                    }
                }
                .background(Color(UIColor.secondarySystemBackground))
            }
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
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
                    .foregroundStyle(.primary)
                
                Text(player.heightFormatted)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(player.gradeRating)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(UIColor.secondarySystemBackground))
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
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        TeamsView(
            players: [
                Player(name: "John Doe", offense: 4, defense: 4, playmaking: 1, athleticism: 5, intangibles: 3, height: 74),
                Player(name: "Jane Smith", offense: 3, defense: 5, playmaking: 3, athleticism: 4, intangibles: 4, height: 70),
                Player(name: "Bob Johnson", offense: 5, defense: 2, playmaking: 2, athleticism: 3, intangibles: 5, height: 78),
                Player(name: "Alice Williams", offense: 2, defense: 4, playmaking: 5, athleticism: 3, intangibles: 3, height: 68)
            ],
            gameState: GameState(courtName: "Central Park", location: "Manhattan, NY"),
            mode: .autoBalance
        )
    }
}
