//
//  TournamentUseCase.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

final class TournamentUseCase: TournamentUseCaseProtocol {
    private let repository: TournamentRepositoryProtocol
    private let tournamentId: UUID
    
    private var matches: [[Match]]  = []
    private var steps: [TournamentStep] = []
    private var historyId: UUID?
    
    init(repository: TournamentRepositoryProtocol, tournamentId: UUID) {
        self.repository = repository
        self.tournamentId = tournamentId
    }
    
    // MARK: - 토너먼트 및 기존 기록 로드
    func loadTournament() async throws -> Tournament {
        let tournament = try await repository.fetchTournament(id: tournamentId)
        self.steps = try await repository.fetchSteps(for: tournamentId)
        self.matches = generateMatches(from: tournament.candidates)
        return tournament
    }
    
    // MARK: - 새로운 플레이 기록 시작
    func startTournament() async throws {
        let history = try await repository.startHistory(for: tournamentId)
        self.historyId = history.id
    }
    
    // MARK: - 선택 결과 저장
    func selectCandidate(candidateA: Candidate, candidateB: Candidate, selected: Candidate, at round: Int, matchIndex: Int, tournamentId: UUID) async throws {
        
        guard let historyId else {
            throw TournamentUseCaseError.historyNotStarted
        }
        
        let step = TournamentStep(
            id: UUID(),
            tournamentId: tournamentId,
            round: round,
            matchIndex: matchIndex,
            candidateAId: candidateA.id,
            candidateBId: candidateB.id,
            selectedCandidateId: selected.id,
            timestamp: Date()
        )
        
        steps.append(step)
        try await repository.saveStep(step, to: historyId)
    }
    
    // MARK: - 토너먼트를 종료하며 우승자를 기록하고 currentHistory를 업데이트
    func finishTournament(winnerId: UUID) async throws {
        guard let historyId else {
            throw TournamentUseCaseError.historyNotStarted
        }
        try await repository.finishHistory(historyId: historyId, winnerId: winnerId)
    }
    
    // MARK: - 현재 진행 중인 매치
    func currentMatch() -> Match? {
        for roundMatches in matches {
            for match in roundMatches {
                let hasStep = steps.contains {
                    $0.round == match.round && $0.matchIndex == match.matchIndex
                }
                if !hasStep {
                    return match
                }
            }
        }
        return nil
    }
    
    // MARK: - 토너먼트 종료 여부
    func isFinished() -> Bool {
        return currentMatch() == nil
    }

    // MARK: - 최종 우승자를 반환
    func winner(from tournament: Tournament) -> Candidate? {
        guard let lastStep = steps.sorted(by: { $0.round > $1.round }).first else {
            return nil
        }
        return tournament.candidates.first(where: { $0.id == lastStep.selectedCandidateId })
    }
    
    // MARK: - 토너먼트 브라켓 생성
    private func generateMatches(from candidates: [Candidate]) {
        
        var shuffled = candidates.shuffled()
//        var result: [[Match]] = []
        var round = 0
        
        while shuffled.count > 1 {
            var roundMatches: [Match] = []
            for i in stride(from: 0, to: shuffled.count, by: 2) {
                let a = shuffled[i]
                let b = shuffled[i + 1]
                roundMatches.append(Match(
                    round: round,
                    matchIndex: i / 2,
                    candidateA: a,
                    candidateB: b
                ))
            }
            matches.append(roundMatches)
            shuffled = roundMatches.map { $0.candidateA } // A 승자 가정
            round += 1
        }
    }
    
    func startHistory(for tournamentId: UUID) async throws -> PlayHistory {
        try await repository.startHistory(for: tournamentId)
    }
}
