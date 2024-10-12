//
//  ForumView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI

struct ForumView: View {
    @StateObject private var noticeViewModel = NoticeViewModel()
    
    private var category = Category()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("공지사항")
                        .font(.system(size: 18, weight: .bold))
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(noticeViewModel.notices) { notice in
                            NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                Text(notice.title)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                    
                    Text("전체 게시판")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.top)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(category.categories, id: \.self) { category in
                            NavigationLink(destination: BoardView(category: category)) {
                                Text(category)
                                    .foregroundColor(.primary)
                            }
                            .padding(6)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .task {
                await noticeViewModel.fetchNotices()
            }
        }
    }
}

#Preview {
    ForumView()
}
