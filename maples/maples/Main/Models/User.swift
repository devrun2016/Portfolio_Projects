//
//  User.swift
//  maples
//
//  Created by 김경완 on 10/10/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var nickName: String
    var email: String
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, nickName: "John Doe", email: "example@example.com")
}
