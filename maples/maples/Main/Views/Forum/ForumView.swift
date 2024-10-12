//
//  ForumView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI

struct ForumView: View {
    private var category = Category()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("전체 게시판")
                        .font(.system(size: 18, weight: .bold))
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(category.categories, id: \.self) { category in
                            NavigationLink(destination: EmptyView()) {
                                Text(category)
                                    .foregroundColor(.primary)
                            }
                            .padding(6)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ForumView()
}
