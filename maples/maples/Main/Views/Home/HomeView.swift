//
//  HomeView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Text("홈")
                .tabItem { Label("홈", systemImage: "house.fill")}
            
            Text("홈")
                .tabItem { Label("홈", systemImage: "house.fill")}
            
            Text("홈")
                .tabItem { Label("홈", systemImage: "house.fill")}
            
            AccountView()
                .tabItem { Label("계정", systemImage: "person.fill")}
        }
    }
}

#Preview {
    HomeView()
}
