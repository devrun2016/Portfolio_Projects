//
//  AuthViewModel.swift
//  maples
//
//  Created by 김경완 on 10/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var nickName: String = ""
    
    @Published var vaildateMessage: String?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    //Email Validation
    func emailValidation(email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    //Password Validation
    func passwordValidation(password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: password)
    }
    
    //Create User
    func createUser(email: String, password: String, nickName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, nickName: nickName, email: email, date: Date(), imageName: "")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id ?? "").setData(encodedUser)
        } catch let error as NSError {
            if let errocde = AuthErrorCode(rawValue: error.code) {
                switch errocde {
                case .emailAlreadyInUse:
                    self.vaildateMessage = "현재 이메일은 사용 중 입니다."
                case .invalidEmail:
                    self.vaildateMessage = "이메일 형식이 아닙니다."
                case .weakPassword:
                    self.vaildateMessage = "비밀번호를 어렵게 만들어주세요"
                default:
                    self.vaildateMessage = "에러를 확인할 수 없습니다. 개발자에게 문의주세요."
                }
            }
        }
    }
    
    func signInUser(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Error: Failed to sign out.")
        }
    }
    
    // 사용자 데이터 가져오기
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
