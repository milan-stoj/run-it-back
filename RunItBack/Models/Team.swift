//
//  Team.swift
//  run-it-back
//
//  Created by Milan Stojanovic on 12/10/25.
//

import Foundation
import SwiftData

@Model
class Team {
    // MARK: - Stored properties
    @Attribute(.unique)
    var id: UUID
    var name: String
    var createdAt: Date

    // MARK: - Initializer required by @Model
    init(id: UUID = UUID(), name: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
    }
}
