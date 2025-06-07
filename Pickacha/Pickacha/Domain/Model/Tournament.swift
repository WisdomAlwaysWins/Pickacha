//
//  Tournament.swift
//  Pickacha
//
//  Created by J on 6/7/25.
//

import Foundation

struct Tournament: Identifiable {
    let id: UUID
    let title: String
    let candidates: [Candidate] // 관계를 ID가 아닌 객체로 보유
    
    // PlayHistories 필드는 도메인 모델에서 유지 X. 나중에 fetch 해서 쓰자!
}
