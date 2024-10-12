//
//  BoardView.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import SwiftUI
import FirebaseAuth

struct BoardView: View {
    var category: String
    @StateObject private var viewModel = PostViewModel() // ViewModel 인스턴스
    
    @State var showWriteForm: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.posts) { post in
                    NavigationLink(destination: ForumDetailView(post: post)) {
                        VStack(alignment: .leading) {
                            Text(post.title)
                            
                            HStack {
                                Text(formattedDate(post.createdAt))
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                                
                                Spacer()
                                
                                Text(post.userName)
                                    .font(.caption)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                    }
                }
                .onDelete(perform: deletePost)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPosts(category: category)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(category)
                    .font(.title)
                    .fontWeight(.medium)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showWriteForm.toggle()
                } label: {
                    Text("글쓰기")
                }
                .fullScreenCover(isPresented: $showWriteForm, onDismiss: {
                    Task {
                        await viewModel.fetchPosts(category: category)
                    }
                }) {
                    ForumWriteView(category: category)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("경고"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }

    
    private func deletePost(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let post = viewModel.posts[index]
                let currentUserID = Auth.auth().currentUser?.uid
                let userName = try await viewModel.fetchUserName(userID: currentUserID ?? "")
                
                if userName == post.userName {
                    await viewModel.deletePost(postId: post.id!) // 게시글 삭제
                } else {
                    alertMessage = "삭제 권한이 없습니다."
                    showAlert = true
                }
            }
            
            await viewModel.fetchPosts(category: category) // 목록 갱신
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    BoardView(category: "Sports")  // 미리보기에서 임의의 카테고리 값을 넣어서 테스트
}
