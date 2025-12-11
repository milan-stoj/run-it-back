//
//  TeamBalancer.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import Foundation
// Import Foundation for access to basic Swift types and utilities

/// A simple container for two teams and helper calculations
struct BalancedTeams {
    let teamA: [Player]  // Players for Team A
    let teamB: [Player]  // Players for Team B
    
    /// Computed property: sums the total ratings for Team A
    var teamATotal: Int {
        // Use reduce starting at 0, adding each player's totalRating
        teamA.reduce(0) { $0 + $1.totalRating }
    }
    
    /// Computed property: sums the total ratings for Team B
    var teamBTotal: Int {
        // Use reduce starting at 0, adding each player's totalRating
        teamB.reduce(0) { $0 + $1.totalRating }
    }
    
    /// Returns the absolute difference between the two team totals
    /// abs is used to ensure non-negative difference regardless of order
    var difference: Int {
        abs(teamATotal - teamBTotal)
    }
    
    /// Simple heuristic for considering teams balanced:
    /// If difference in total ratings is less than or equal to 5
    var isBalanced: Bool {
        difference <= 5
    }
}

/// Contains algorithms and utilities to split players into two teams
class TeamBalancer {
    
    /// Auto-balance teams using running team totals
    /// Players are first sorted by total rating in descending order (highest first).
    /// Then, by enumerating the sorted list, players are assigned alternately to Team A and
    /// Team B depending on who has the highest rating total.
    /// Returns a BalancedTeams struct containing the two teams.
    static func balanceTeams(players: [Player]) -> BalancedTeams {
        // Sort players by total rating (descending) — highest rated players first
        let sortedPlayers = players.sorted { $0.totalRating > $1.totalRating }
        
        // Start with empty arrays to build the teams
        var teamA: [Player] = []
        var teamB: [Player] = []
        
        var teamATotal: Int = 0;
        var teamBTotal: Int = 0;
        
        // Enumerate the sorted players: gives both index and player
        for (_, player) in sortedPlayers.enumerated() {
            teamATotal = getTeamTotal(team: teamA);
            teamBTotal = getTeamTotal(team: teamB);
            
            if teamATotal > teamBTotal {  // if teamA has a higher total, append next best player to teamB
                teamB.append(player)
            } else {
                teamA.append(player)
            }
        }
        
        // Wrap the two arrays in the BalancedTeams struct for convenience
        return BalancedTeams(teamA: teamA, teamB: teamB)
    }
    
    /// Calculate total rating for a team
    /// This method sums the totalRating of all players in any given team array.
    /// It can be used whenever you need to get the overall strength of a team.
    static func getTeamTotal(team: [Player]) -> Int {
        // Use reduce starting at 0, adding each player's totalRating
        team.reduce(0) { $0 + $1.totalRating }
    }
}

