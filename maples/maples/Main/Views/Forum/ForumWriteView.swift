//
//  ForumWriteView.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import SwiftUI

struct ForumWriteView: View {
    @Environment(\.presentationMode) var presentationMode
    private let writeViewModel = WriteViewModel()
    private let postViewModel = PostViewModel()
    
    var category: String
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("카테고리: ")
                    .fontWeight(.medium)
                
                Text(category)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("제목")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                TextField("제목을 입력하세요", text: $title)
                    .padding(6)
                    .overlay( // 보더 구현
                        Rectangle()
                            .stroke(Color.gray, lineWidth: 1) // 회색 보더
                    )
                    .padding(.bottom)
                
                Text("내용")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                TextEditor(text: $content)
                    .padding(6)
                    .overlay( // 보더 구현
                        Rectangle()
                            .stroke(Color.gray, lineWidth: 1) // 회색 보더
                    )
            }
            .padding(.bottom)
            
            Button("게시글 등록") {
                Task {
                    try await writeViewModel.addPost(category: category, title: title, content: content)
                    title = ""
                    content = ""   
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(.black)
            .foregroundColor(.white)
            .fontWeight(.bold)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ForumWriteView(category: "")
}
