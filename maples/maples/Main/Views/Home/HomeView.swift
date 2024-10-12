//
//  HomeView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI

struct HomeView: View {
    //View Models
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            ForumView()
                .tabItem { Label("커뮤니티", systemImage: "square.fill.text.grid.1x2")}
            
            AccountView()
                .tabItem { Label("계정", systemImage: "person.fill")}
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
