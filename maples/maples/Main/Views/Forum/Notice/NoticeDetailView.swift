//
//  NoticeDetailView.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import SwiftUI

struct NoticeDetailView: View {
    var notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.title)
                .font(.largeTitle)
                .padding()
            Text(notice.content)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}
