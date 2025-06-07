//
//  TournamentEntity.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import SwiftData

@Model
final class TournamentEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \CandidateEntity.tournament) var candidates: [CandidateEntity] = []
    @Relationship(deleteRule: .cascade, inverse: \PlayHistoryEntity.tournament) var playHistories: [PlayHistoryEntity] = []
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
    
    func toDomain() -> Tournament {
        Tournament(id: self.id, title: self.title, candidates: self.candidates.map { $0.toDomain() })
    }
}
