//
//  ResultView.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import SwiftUI

struct ResultView: View {
    let winner: Candidate
    
    var body: some View {
        VStack(spacing: 24) {
            Text("최종 우승자")
                .font(.largeTitle)
                .bold()
            Text(winner.name)
                .font(.largeTitle)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.2))
                )
                .padding()
            Text("당신의 선택이 반영되었습니다!")
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ResultView(winner: Candidate(id: UUID(), name: "잠만보"))
}
