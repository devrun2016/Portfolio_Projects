//
//  PostViewModel.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = [] //Post Model
    @Published var comments: [Comment] = [] // Comment Model
    
    private let db = Firestore.firestore() //Declare Firebase
    
    func deletePost(postId: String) async {
        do {
            try await db.collection("post").document(postId).delete()
            // 삭제 후 게시물 목록을 다시 가져오기
            await fetchPosts(category: "게시물 카테고리") // 필요에 따라 카테고리를 업데이트
        } catch {
            print("Error deleting post: \(error.localizedDescription)")
        }
    }
    
    func deleteComment(postId: String, commentId: String) async {
        do {
            try await db.collection("post").document(postId).collection("comments").document(commentId).delete()
            await fetchComments(postId: postId) // 삭제 후 댓글 다시 불러오기
        } catch {
            print("Error deleting comment: \(error.localizedDescription)")
        }
    }

    // 댓글 불러오기 메서드 (fetchComments)
    func fetchComments(postId: String) async {
        do {
            let snapshot = try await db.collection("post").document(postId).collection("comments").getDocuments()
            
            let fetchedPosts = snapshot.documents.compactMap { document -> Comment? in
                try? document.data(as: Comment.self)
            }

            DispatchQueue.main.async {
                self.comments = fetchedPosts
            }
        } catch {
            print("Error fetching comments: \(error.localizedDescription)")
        }
    }

    // 댓글 추가 메서드 (addComment)
    func addComment(postId: String, comment: String) async {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }

        do {
            let userName = try await fetchUserName(userID: currentUser.uid) ?? "Unknown User"

            let commentData: [String: Any] = [
                "text": comment, // "text" 키를 사용하여 저장
                "userName": userName,
                "createdAt": Timestamp()
            ]

            _ = try await db.collection("post").document(postId).collection("comments").addDocument(data: commentData)

            // 댓글 추가 후 다시 불러오기
            await fetchComments(postId: postId)
        } catch {
            print("Error adding comment: \(error.localizedDescription)")
        }
    }

    // 사용자 이름 가져오는 메서드 (fetchUserName)
    func fetchUserName(userID: String) async throws -> String? {
        let userDoc = try await db.collection("users").document(userID).getDocument()
        return userDoc.get("nickName") as? String
    }


    //Get Posts
    func fetchPosts(category: String) async {
        do {
            //Define collection
            let snapshot = try await db.collection("post")
                .whereField("category", isEqualTo: category)
                .getDocuments()

            //Fetch Post
            let fetchedPosts = snapshot.documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            }

            //Sort by date
            let sortedPosts = fetchedPosts.sorted {
                $0.createdAt > $1.createdAt
            }

            DispatchQueue.main.async {
                self.posts = sortedPosts
            }

            
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
        }
    }
}
