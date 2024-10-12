//
//  Notice.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore

struct Notice: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore 문서 ID
    let title: String
    let content: String
}
