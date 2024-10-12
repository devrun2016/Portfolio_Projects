//
//  Comment.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    @DocumentID var id: String? // Firestore의 문서 ID
    var userName: String
    var text: String
    var createdAt: Date // 날짜 필드 추가
}
