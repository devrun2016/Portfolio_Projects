//
//  User.swift
//  HairSalon
//
//  Created by 김경완 on 10/14/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let profile: Profile
}

struct Profile: Codable {
    let nickName: String
    let profileImageURL: String
}
