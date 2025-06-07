//
//  TournamentView.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import SwiftUI

struct TournamentView: View {
    
    @StateObject private var viewModel: TournamentViewModel
    
    init(tournamentId: UUID, useCase: TournamentUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: TournamentViewModel(useCase: useCase, tournamentId: tournamentId))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            if viewModel.isLoading {
                ProgressView("불러오는 중...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Text(error)
                        .foregroundColor(.red)
                    Button("다시 시도하기") {
                        Task {
                            await viewModel.loadTournament()
                        }
                    }
                }
            } else if viewModel.isFinished, let winner = viewModel.winner {
                ResultView(winner: winner)
            } else if let match = viewModel.currentMatch {
                MatchView(match: match, onSelect: { selected in
                    Task {
                        await viewModel.select(selected)
                    }
                })
            } else {
                Text("진행할 경기가 없습니다.")
            }
        }
        .padding()
    }
}

#Preview {
    TournamentView(
        tournamentId: UUID(), useCase: MockTournamentUseCase()
    )
}
