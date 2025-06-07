//
//  MockTournamentUseCase.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

final class MockTournamentUseCase: TournamentUseCaseProtocol {
    var selectedSteps: [TournamentStep] = []
    private var internalMatch: Match?
    
    func fetchTournament(id: UUID) async throws -> Tournament {
        let c1 = Candidate(id: UUID(), name: "🍕")
        let c2 = Candidate(id: UUID(), name: "🍔")
        internalMatch = Match(round: 0, matchIndex: 0, candidateA: c1, candidateB: c2)
        return Tournament(id: id, title: "음식 토너먼트", candidates: [c1, c2])
    }
    
    func startTournament(id: UUID) async throws {
        
    }
    
    func finishTournament(winnerId: UUID) async throws {
        
    }
    
    func currentMatch() -> Match? {
        return internalMatch
    }
    
    func isFinished() -> Bool {
        return selectedSteps.count >= 1
    }
    
    func winner(from tournament: Tournament) -> Candidate? {
        guard let selected = selectedSteps.first else {
            return nil
        }
        return tournament.candidates.first(where: { $0.id == selected.selectedCandidateId })
    }
    
    func selectCandidate(candidateA: Candidate, candidateB: Candidate, selected: Candidate, at round: Int, matchIndex: Int, tournamentId: UUID) async throws {
        let step = TournamentStep (id: UUID(), tournamentId: tournamentId, round: round, matchIndex: matchIndex, candidateAId: candidateA.id, candidateBId: candidateB.id, selectedCandidateId: selected.id, timestamp: Date()
        )
        selectedSteps.append(step)
        internalMatch = nil
    }
}
