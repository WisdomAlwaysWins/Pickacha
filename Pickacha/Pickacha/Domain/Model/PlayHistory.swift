//
//  PlayHistory.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

struct PlayHistory {
    let id: UUID
    let tournamentId: UUID
    let startedAt: Date
    let endedAt: Date?
    let winnerId: UUID?
    let steps: [TournamentStep]
}
