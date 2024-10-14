//
//  ContentView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    //Imported ViewModels
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.userSession != nil {
            MainTabView()
        } else {
            SignInView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
