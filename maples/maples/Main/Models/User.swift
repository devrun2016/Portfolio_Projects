//
//  User.swift
//  maples
//
//  Created by 김경완 on 10/10/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var nickName: String
    var email: String
    var date: Date
    var imageName: String?
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, nickName: "John Doe", email: "example@example.com", date: Date())
}
