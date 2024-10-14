//
//  HomeView.swift
//  HairSalon
//
//  Created by 김경완 on 10/14/24.
//

import SwiftUI

struct HomeView: View {
    //Imported ViewModels
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Button("signOut") {
                Task {
                    await authViewModel.signOut()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
