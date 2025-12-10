//
//  TeamBalancer.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import Foundation

struct BalancedTeams {
    let teamA: [Player]
    let teamB: [Player]
    
    var teamATotal: Int {
        teamA.reduce(0) { $0 + $1.totalRating }
    }
    
    var teamBTotal: Int {
        teamB.reduce(0) { $0 + $1.totalRating }
    }
    
    var difference: Int {
        abs(teamATotal - teamBTotal)
    }
    
    var isBalanced: Bool {
        difference <= 5
    }
}

class TeamBalancer {
    
    /// Auto-balance teams using snake draft algorithm
    /// Players are sorted by total rating (descending), then alternately assigned to teams
    static func balanceTeams(players: [Player]) -> BalancedTeams {
        // Sort players by total rating (descending)
        let sortedPlayers = players.sorted { $0.totalRating > $1.totalRating }
        
        var teamA: [Player] = []
        var teamB: [Player] = []
        
        // Snake draft: alternate assignments
        for (index, player) in sortedPlayers.enumerated() {
            if index % 2 == 0 {
                teamA.append(player)
            } else {
                teamB.append(player)
            }
        }
        
        return BalancedTeams(teamA: teamA, teamB: teamB)
    }
    
    /// Calculate total rating for a team
    static func getTeamTotal(team: [Player]) -> Int {
        team.reduce(0) { $0 + $1.totalRating }
    }
}
