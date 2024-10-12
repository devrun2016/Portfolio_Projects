//
//  AccountView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI
import FirebaseAuth
import _PhotosUI_SwiftUI

struct AccountView: View {
    //View Models
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var accountViewModel = AccountViewModel()

    var body: some View {
        VStack {
            ProfileImageView()
                .padding(.bottom, 20)
            
            if let user = authViewModel.currentUser {
                Text(user.nickName)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.bottom, 20)
            }
            
            VStack(alignment: .leading) {
                Section("앱") {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            
                            Text("로그아웃")
                                .font(.system(size: 14, weight: .medium))
                            
                            Spacer()
                        }
                    }
                    .padding(2)
                }
                .foregroundColor(Color(.systemGray))
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthViewModel())
}
