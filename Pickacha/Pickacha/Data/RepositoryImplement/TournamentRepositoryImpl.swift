//
//  TournamentRepositoryImpl.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import SwiftData

final class TournamentRepositoryImpl: TournamentRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchTournament(id: UUID) async throws -> Tournament {
        let descriptor = FetchDescriptor<TournamentEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let tournamentEntity = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        let candidates = tournamentEntity.candidates.map { // CandidateEntity를 Candidate로 매핑
            Candidate(id: $0.id, name: $0.name)
        }
        
        return Tournament(id: tournamentEntity.id, title: tournamentEntity.title, candidates: candidates)
    }
    
    func fetchAllTournaments() async throws -> [Tournament] {
        let descriptor = FetchDescriptor<TournamentEntity>(sortBy: [SortDescriptor(\.id)])
        let tournamentEntity = try context.fetch(descriptor)
        return tournamentEntity.map { $0.toDomain() }
    }
    
    func fetchSteps(for tournamentId: UUID) async throws -> [TournamentStep] {
        let descriptor = FetchDescriptor<TournamentStepEntity>(
            predicate: #Predicate { $0.tournamentId == tournamentId },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        let stepEntity = try context.fetch(descriptor)
        
        return stepEntity.map { $0.toDomain() }
    }
    
    func saveStep(_ step: TournamentStep, to historyId: UUID) async throws {
        
        let targetId = step.tournamentId
        
        // 1. 히스토리 조회
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            predicate: #Predicate { entity in
                entity.id == targetId
            }
        )
        
        guard let history = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        // 2. Step 저장
        let stepEntity = TournamentStepEntity(
            tournamentId: step.tournamentId,
            round: step.round,
            matchIndex: step.matchIndex,
            candidateAId: step.candidateAId,
            candidateBId: step.candidateBId,
            selectedCandidateId: step.selectedCandidateId,
            timestamp: step.timestamp,
            history: history
        )
        context.insert(stepEntity)
    
        // 3. 우승자 결정 여부 판단
        let tournament = history.tournament
        let totalMatches = Int(pow(2.0, Double(step.round + 1))) / 2
        let isLastStepInRound = step.matchIndex == totalMatches - 1
        let isFinalRound = step.round == Int(log2(Double(tournament.candidates.count))) - 1
        
        if isLastStepInRound && isFinalRound {
            history.endedAt = Date()
            history.winnerId = step.selectedCandidateId
        }
        
        try context.save()
    }

    func startHistory(for tournamentId: UUID) async throws -> PlayHistory {
        let descriptor = FetchDescriptor<TournamentEntity>(
            predicate: #Predicate { $0.id == tournamentId }
        )
        
        guard let tournament = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        let historyEntity = PlayHistoryEntity(tournament: tournament)
        context.insert(historyEntity)
        try context.save()
        
        return historyEntity.toDomain()
    }
    
    func finishHistory(historyId: UUID, winnerId: UUID) async throws -> PlayHistory {
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            predicate: #Predicate { $0.id == historyId }
        )
        
        guard let history = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        history.endedAt = Date()
        history.winnerId = winnerId
        
        try context.save()
        
        return history.toDomain()
    }
    
    func saveHistory(_ history: PlayHistory) async throws {
        
        let targetId = history.tournamentId
        
        // TournamentEntity 찾기
        let descriptor = FetchDescriptor<TournamentEntity>(
            predicate: #Predicate { $0.id == targetId }
        )
        
        guard let tournament = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        // PlayHistoryEntity 생성
        let historyEntity = PlayHistoryEntity(tournament: tournament)
        historyEntity.id = history.id
        historyEntity.startedAt = history.startedAt
        historyEntity.endedAt = history.endedAt
        historyEntity.winnerId = history.winnerId
        
        // steps도 함께 저장
        for step in history.steps {
            let stepEntity = TournamentStepEntity(
                tournamentId: step.tournamentId,
                round: step.round,
                matchIndex: step.matchIndex,
                candidateAId: step.candidateAId,
                candidateBId: step.candidateBId,
                selectedCandidateId: step.selectedCandidateId,
                timestamp: step.timestamp,
                history: historyEntity
            )
            stepEntity.id = step.id
            context.insert(stepEntity)
        }
        context.insert(historyEntity)
        try context.save()
    }
    
    func fetchHistories(for tournamentId: UUID) async throws -> [PlayHistory] {
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            predicate: #Predicate { $0.tournament.id == tournamentId },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        
        let entities = try context.fetch(descriptor)
        return entities.map { $0.toDomain() }
    }
    
    func fetchHistory(id: UUID) async throws -> PlayHistory {
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let entity = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        return entity.toDomain()
    }
    
    func fetchAllHistories() async throws -> [PlayHistory] {
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        
        let historyEntity = try context.fetch(descriptor)
        
        return historyEntity.map { $0.toDomain() }
    }
    
    func deleteHistory(id: UUID) async throws {
        let descriptor = FetchDescriptor<PlayHistoryEntity>(
            predicate: #Predicate { $0.id == id }
        )
        
        guard let entity = try context.fetch(descriptor).first else {
            throw RepositoryError.notFound
        }
        
        context.delete(entity)
        try context.save()
    }
}
