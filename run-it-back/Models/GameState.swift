//
//  GameState.swift
//  Run It Back
//
//  Created on December 9, 2025.
//

import Foundation

enum GameType: String, Codable, CaseIterable {
    case threeVThree = "3v3"
    case fourVFour = "4v4"
    case fiveVFive = "5v5"
}

struct GameState: Codable {
    var courtName: String
    var location: String
    var date: Date
    var gameType: GameType
    
    init(
        courtName: String = "",
        location: String = "",
        date: Date = Date(),
        gameType: GameType = .fiveVFive
    ) {
        self.courtName = courtName
        self.location = location
        self.date = date
        self.gameType = gameType
    }
    
    var isValid: Bool {
        !courtName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !location.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
