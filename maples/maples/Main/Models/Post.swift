//
//  Post.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var category: String
    var title: String
    var content: String
    var createdAt: Date
    var userName: String
}
