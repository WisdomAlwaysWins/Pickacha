//
//  CandidateEntity.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import SwiftData

@Model
class CandidateEntity {
    @Attribute(.unique) var id: UUID
    var name: String

    @Relationship var tournament: TournamentEntity

    init(id: UUID = UUID(), name: String, tournament: TournamentEntity) {
        self.id = id
        self.name = name
        self.tournament = tournament
    }
    
    func toDomain() -> Candidate {
        Candidate(id: self.id, name: self.name)
    }
}
