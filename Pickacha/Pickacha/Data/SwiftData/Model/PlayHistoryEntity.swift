//
//  PlayHistoryEntity.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import SwiftData

@Model
class PlayHistoryEntity {
    @Attribute(.unique) var id: UUID
    var startedAt: Date
    var endedAt: Date?
    var winnerId: UUID?

    @Relationship var tournament: TournamentEntity
    @Relationship(deleteRule: .cascade, inverse: \TournamentStepEntity.history) var steps: [TournamentStepEntity] = []

    init(tournament: TournamentEntity) {
        self.id = UUID()
        self.startedAt = Date()
        self.tournament = tournament
    }
    
    func toDomain() -> PlayHistory {
        PlayHistory(
            id: self.id,
            tournamentId: self.tournament.id,
            startedAt: self.startedAt,
            endedAt: self.endedAt,
            winnerId: self.winnerId,
            steps: self.steps.map { $0.toDomain() }
        )
    }
}
