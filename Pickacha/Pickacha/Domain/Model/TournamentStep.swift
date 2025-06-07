//
//  TournamentStep.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

struct TournamentStep {
    let id: UUID
    let tournamentId: UUID
    let round: Int
    let matchIndex: Int
    let candidateAId: UUID
    let candidateBId: UUID
    let selectedCandidateId: UUID
    let timestamp: Date
}
