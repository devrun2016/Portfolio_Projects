//
//  ForumDetailView.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import SwiftUI

struct ForumDetailView: View {
    @StateObject private var viewModel = PostViewModel()
    @State private var commentText: String = ""
    
    var post: Post
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(formattedDate(post.createdAt))
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                        
                        Text(post.userName)
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
                    }
                    .padding(.bottom)
                    
                    Text(post.content)
                }
                .padding(.bottom)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.7) // 게시글 부분
            
            HStack {
                Text("댓글")
                    .font(.subheadline)
                    .padding(.top)
                
                Spacer()
            }
            
            // 댓글 리스트
            List {
                ForEach(viewModel.comments) { comment in
                    HStack {
                        Text(comment.text)
                        
                        Spacer()
                        
                        Text(comment.userName)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let commentId = viewModel.comments[index].id ?? ""
                        
                        Task {
                            await viewModel.deleteComment(postId: post.id ?? "", commentId: commentId)
                        }
                    }
                }
            }
            .listStyle(.plain)

            // 댓글 입력
            HStack {
                TextField("댓글", text: $commentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("등록") {
                    Task {
                        await viewModel.addComment(postId: post.id ?? "", comment: commentText)
                        commentText = ""
                        await viewModel.fetchComments(postId: post.id!) // 댓글 다시 불러오기
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.fetchComments(postId: post.id ?? "") // 게시글의 댓글 불러오기
            }
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
    ForumDetailView(post: Post(category: "카테고리", title: "ㅇㅇ", content: "ㅇㅇ", createdAt: Date(), userName: "dd"))
}


