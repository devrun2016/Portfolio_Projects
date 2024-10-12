//
//  WriteViewModel.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WriteViewModel: ObservableObject {
    //Declare firestore
    let db = Firestore.firestore()
    
    func addPost(category: String, title: String, content: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }
        
        do {
            let userName = try await fetchUserName(userID: currentUser.uid) ?? "Unknown User"
            
            try await db.collection("post").addDocument(data: [
                "category": category,
                "title": title,
                "content": content,
                "userName": userName,
                "createdAt": Date()
            ])
            
        } catch {
            print("error")
        }
    }
    
    func fetchUserName(userID: String) async throws -> String? {
        let userDoc = try await db.collection("users").document(userID).getDocument()
        return userDoc.get("nickName") as? String
    }
}
