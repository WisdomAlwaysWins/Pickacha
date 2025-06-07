//
//  TournamentUseCaseProtocol.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

protocol TournamentUseCaseProtocol {
    /// 주어진 ID로 토너먼트 정보를 불러옵니다.
    func fetchTournament(id: UUID) async throws -> Tournament
    /// 주어진 ID의 토너먼트를 시작하고 히스토리를 생성합니다.
    func startTournament(id: UUID) async throws
    /// 주어진 후보를 선택해 TournamentStep을 저장합니다.
    func selectCandidate(
        candidateA: Candidate,
        candidateB: Candidate,
        selected: Candidate,
        at round: Int,
        matchIndex: Int,
        tournamentId: UUID
    ) async throws
    /// 모든 선택이 완료되었는지 여부를 반환합니다.
    func isFinished() -> Bool
    /// 아직 선택되지 않은 현재 매치를 반환합니다.
    func currentMatch() -> Match?
    /// 토너먼트 종료 후 우승자를 반환합니다.
    func winner(from tournament: Tournament) -> Candidate?
    /// 히스토리를 종료하고 우승자를 기록합니다.
    func finishTournament(winnerId: UUID) async throws
    func startHistory(for tournamentId: UUID) async throws -> PlayHistory
}

