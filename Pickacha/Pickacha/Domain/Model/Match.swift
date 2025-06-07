//
//  Match.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

struct Match { // 실제 화면에 표시되는 1:1 매치 정보
    let round: Int
    let matchIndex: Int
    let candidateA: Candidate
    let candidateB: Candidate
}
