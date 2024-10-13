//
//  AuthViewModel.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func createUser(email: String, password: String, nickName: String, profileImageURL: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let profile = Profile(nickName: nickName, profileImageURL: profileImageURL)
            let User = User(id: result.user.uid, email: email, profile: profile)
            let userData = try Firestore.Encoder().encode(User)
            
            try await Firestore.firestore().collection("users").document(User.id).setData(userData)
        } catch {
            print("Auth Error: \(error.localizedDescription)")
        }
    }
}


