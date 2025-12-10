//
//  PlayerStore.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import Foundation
import SwiftData

@MainActor
class PlayerStore {
    /// Fetch all saved players from the library
    static func fetchSavedPlayers(context: ModelContext) -> [Player] {
        let descriptor = FetchDescriptor<Player>(
            predicate: #Predicate { $0.isSaved == true },
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching saved players: \(error)")
            return []
        }
    }
    
    /// Save a new player to the library
    static func savePlayer(_ player: Player, context: ModelContext) {
        player.isSaved = true
        context.insert(player)
        
        do {
            try context.save()
        } catch {
            print("Error saving player: \(error)")
        }
    }
    
    /// Create a temporary copy of a saved player for a game session
    static func createGameCopy(of player: Player) -> Player {
        return Player(
            name: player.name,
            scoring: player.scoring,
            defense: player.defense,
            playmaking: player.playmaking,
            athleticism: player.athleticism,
            intangibles: player.intangibles,
            height: player.height,
            isSaved: false
        )
    }
    
    /// Update an existing player
    static func updatePlayer(_ player: Player, context: ModelContext) {
        do {
            try context.save()
        } catch {
            print("Error updating player: \(error)")
        }
    }
    
    /// Delete a player from the library
    static func deletePlayer(_ player: Player, context: ModelContext) {
        context.delete(player)
        
        do {
            try context.save()
        } catch {
            print("Error deleting player: \(error)")
        }
    }
    
    /// Search players by name
    static func searchPlayers(query: String, context: ModelContext) -> [Player] {
        let descriptor = FetchDescriptor<Player>(
            predicate: #Predicate { player in
                player.isSaved == true && player.name.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.name)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error searching players: \(error)")
            return []
        }
    }
}
