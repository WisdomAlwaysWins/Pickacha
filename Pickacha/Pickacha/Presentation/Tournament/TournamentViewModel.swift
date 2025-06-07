//
//  TournamentViewModel.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation
import Combine

final class TournamentViewModel: ObservableObject {
    // MARK: - Dependencies
    private let useCase: TournamentUseCaseProtocol
    private let tournamentId: UUID
    
    // MARK: - UI State
    @Published var tournament: Tournament?
    @Published var currentMatch: Match?
    @Published var isFinished: Bool = false
    @Published var winner: Candidate?
    @Published var currentHistoryId: UUID?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Init
    init(useCase: TournamentUseCaseProtocol, tournamentId: UUID) {
        self.useCase = useCase
        self.tournamentId = tournamentId
        
        Task {
            await loadTournament()
        }
    }
    
    // MARK: - Load & Progress
    
    // MARK: - 토너먼트와 현재 상태 불러오기
    func loadTournament() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loaded = try await useCase.fetchTournament(id: tournamentId)
            self.tournament = loaded
            
            // 히스토리 생성
            let history = try await useCase.startHistory(for: tournamentId)
            self.currentHistoryId = history.id
            
            self.currentMatch = useCase.currentMatch()
            self.isFinished = useCase.isFinished()
            self.winner = useCase.winner(from: loaded)
        } catch {
            errorMessage = "토너먼트를 불러오는 데 실패했습니다."
            print("[ERROR] Loading Tournament Failed: ", error)
        }
        
        isLoading = false
    }
    
    // MARK: - 후보 선택 -> 스탭 저장 -> 다음 매치로 갱신
    func select(_ candidate: Candidate) async { // MARK: -
        guard let match = currentMatch,
              let tournament else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await useCase.selectCandidate(
                candidateA: match.candidateA,
                candidateB: match.candidateB,
                selected: candidate,
                at: match.round,
                matchIndex: match.matchIndex,
                tournamentId: tournament.id
            )
            
            currentMatch = useCase.currentMatch()
            isFinished = useCase.isFinished()
            winner = useCase.winner(from: tournament)
            
        } catch {
            errorMessage = "선택을 저장하는 데 실패했습니다."
            print("[ERROR] Selecting Candidate: ", error)
        }
        
        isLoading = false
    }
    
}
