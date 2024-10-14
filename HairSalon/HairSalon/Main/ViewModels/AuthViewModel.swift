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
    
    @Published var validationError: String = ""
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signIn(email: String, password: String) async throws {
        guard isValidEmail(email) else {
            validationError = "Invalid email"
            return
        }
        
        guard isValidPassword(password) else {
            validationError = "Need strong password"
            return
        }
        
        guard !email.isEmpty, !password.isEmpty else {
            validationError = "Need user email and password"
            return
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("Error")
        }
    }
    
    func createUser(email: String, password: String, userName: String) async throws {
        guard isValidEmail(email) else {
            validationError = "Invalid email"
            return
        }
        
        guard isValidPassword(password) else {
            validationError = "Need strong password"
            return
        }
        
        guard !userName.isEmpty else {
            validationError = "Need username"
            return
        }
        
        guard userName.count >= 3 else {
            validationError = "User name should be at least 3 characters"
            return
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(uid: result.user.uid, username: userName, joinDate: Date())
            let encodedUser = try Firestore.Encoder().encode(user)
            
            try await Firestore.firestore().collection("users").document(user.uid).setData(encodedUser)
        } catch {
            print("Auth Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("Error: Cannot Sign Out")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // simple email checker
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // simple password checker
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
}
