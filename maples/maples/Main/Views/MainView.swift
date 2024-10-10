//
//  ContentView.swift
//  maples
//
//  Created by 김경완 on 10/10/24.
//

import SwiftUI

struct MainView: View {
    //View Models
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.userSession != nil {
            HomeView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
}
