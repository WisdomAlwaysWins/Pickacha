//
//  TournamentStepEntity.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import SwiftData

@Model
class TournamentStepEntity {
    @Attribute(.unique) var id: UUID
    var tournamentId: UUID
    var round: Int
    var matchIndex: Int
    var candidateAId: UUID
    var candidateBId: UUID
    var selectedCandidateId: UUID
    var timestamp: Date

    @Relationship var history: PlayHistoryEntity

    init(
        tournamentId: UUID,
        round: Int,
        matchIndex: Int,
        candidateAId: UUID,
        candidateBId: UUID,
        selectedCandidateId: UUID,
        timestamp: Date = Date(),
        history: PlayHistoryEntity
    ) {
        self.id = UUID()
        self.tournamentId = tournamentId
        self.round = round
        self.matchIndex = matchIndex
        self.candidateAId = candidateAId
        self.candidateBId = candidateBId
        self.selectedCandidateId = selectedCandidateId
        self.timestamp = timestamp
        self.history = history
    }
    
    func toDomain() -> TournamentStep {
        TournamentStep(
            id: self.id,
            tournamentId: self.tournamentId,
            round: self.round,
            matchIndex: self.matchIndex,
            candidateAId: self.candidateAId,
            candidateBId: self.candidateBId,
            selectedCandidateId: self.selectedCandidateId,
            timestamp: self.timestamp
        )
    }
}
