//
//  Player.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import Foundation
import SwiftData

@Model
class Player {
    @Attribute(.unique) var id: UUID
    var name: String
    var scoring: Int
    var defense: Int
    var playmaking: Int
    var athleticism: Int
    var intangibles: Int
    var height: Int // in inches
    var isSaved: Bool // Track if player is in permanent library
    
    init(
        id: UUID = UUID(),
        name: String,
        scoring: Int = 3,
        defense: Int = 3,
        playmaking: Int = 3,
        athleticism: Int = 3,
        intangibles: Int = 3,
        height: Int = 72,
        isSaved: Bool = false
    ) {
        self.id = id
        self.name = name
        self.scoring = scoring
        self.defense = defense
        self.playmaking = playmaking
        self.athleticism = athleticism
        self.intangibles = intangibles
        self.height = height
        self.isSaved = isSaved
    }
    
    // Calculate base rating (sum of all skills)
    var baseRating: Int {
        scoring + defense + playmaking + athleticism + intangibles
    }
    
    // Height bonus: +1 per 3 inches above 6'0" (72 inches)
    var heightBonus: Int {
        max(0, (height - 72) / 3)
    }
    
    // Total rating including height bonus
    var totalRating: Int {
        baseRating + heightBonus
    }
    
    // Formatted height string (e.g., "6'2\"")
    var heightFormatted: String {
        let feet = height / 12
        let inches = height % 12
        return "\(feet)'\(inches)\""
    }
}
