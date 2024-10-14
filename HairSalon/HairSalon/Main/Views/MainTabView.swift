//
//  MainTabView.swift
//  HairSalon
//
//  Created by 김경완 on 10/14/24.
//

import SwiftUI

struct MainTabView: View {
    //Imported ViewModels
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            
            Text("홈")
                .tabItem { Label("Home", systemImage: "house") }
            
            Text("홈")
                .tabItem { Label("Home", systemImage: "house") }
            
            Text("홈")
                .tabItem { Label("Account", systemImage: "person.circle.fill") }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
