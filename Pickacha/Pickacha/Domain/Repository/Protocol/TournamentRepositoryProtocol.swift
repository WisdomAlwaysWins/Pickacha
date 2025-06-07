//
//  TournamentRepositoryProtocol.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

protocol TournamentRepositoryProtocol {
    func fetchTournament(id: UUID) async throws -> Tournament // 특정 토너먼트 1개 조회
    func fetchAllTournaments() async throws -> [Tournament] // 전체 토너먼트 조회
    
    func fetchSteps(for tournamentId: UUID) async throws -> [TournamentStep] // 특정 토너먼트의 step(선택 내역) 전체 조회
    func saveStep(_ step: TournamentStep, to historyId: UUID) async throws // step 저장(진행 중인 매치 결과 저장)
    
    func startHistory(for tournamentId: UUID) async throws -> PlayHistory // 플레이 히스토리 시작 (시작시간 저장)
    func finishHistory(historyId: UUID, winnerId: UUID) async throws -> PlayHistory // 히스토리 종료 (종료 시간 + 우승자 저장)
    func saveHistory(_ history: PlayHistory) async throws // 수동으로 히스토리 전체 저장 (필요시)
    
    func fetchHistories(for tournamentId: UUID) async throws -> [PlayHistory] // 특정 토너먼트의 히스토리 목록 조회
    func fetchHistory(id: UUID) async throws -> PlayHistory // 특정 히스토리 1개 조회
    func fetchAllHistories() async throws -> [PlayHistory] // 전체 히스토리 조회
    func deleteHistory(id: UUID) async throws // 특정 히스토리 삭제
}
