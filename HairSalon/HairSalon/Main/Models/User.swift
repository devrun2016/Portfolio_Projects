//
//  User.swift
//  HairSalon
//
//  Created by 김경완 on 10/14/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let uid: String
    var username: String
    var profileImageURL: String?
    var joinDate: Date
}
