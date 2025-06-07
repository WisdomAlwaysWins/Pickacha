//
//  MatchView.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import SwiftUI

struct MatchView: View {
    let match: Match
    let onSelect: (Candidate) -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("라운드 \(match.round + 1)")
                .font(.title2)
                .bold()
            
            HStack(spacing: 32) {
                CandidateButton(candidate: match.candidateA, action: {
                    onSelect(match.candidateA)
                })
                
                CandidateButton(candidate: match.candidateB, action: {
                    onSelect(match.candidateB)
                })
            }
        }
        .padding()
    }
}

private struct CandidateButton: View {
    let candidate: Candidate
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(candidate.name)
                .font(.headline)
                .padding()
                .frame(width: 120, height: 120)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(16)
        }
    }
}

#Preview {
    MatchView(
        match: Match(
            round: 0,
            matchIndex: 0,
            candidateA: Candidate(id: UUID(), name: "피카츄"),
            candidateB: Candidate(id: UUID(), name: "라이츄")
        ),
        onSelect: { candidate in
            print("Selected: \(candidate.name)")
        }
    )
}
