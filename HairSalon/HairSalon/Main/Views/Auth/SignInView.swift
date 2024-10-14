//
//  SignInView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct SignInView: View {
    //Imported ViewModels
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //Import Files
    private let appColor = AppColor()
    
    //State Properties
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                //App Logo Image
                Image(.appicons)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                //Input Field
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(.system(size: 16, weight: .regular))
                    
                    TextField("Enter your emaill adress", text: $email)
                        .padding(.bottom)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Text("Password")
                        .font(.system(size: 16, weight: .regular))
                    
                    SecureField("Enter your password", text: $password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                .padding(.top, 40)
                
                Text("\(authViewModel.validationError)")
                    .font(.caption)
                    .foregroundColor(.red)
                
                //Find Password
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: FindPasswordView()) {
                        Text("Forgot Password?")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(appColor.grayTextColor)
                    }
                }
                .padding(.top, 10)
                
                //Sign In Button
                Button("Sign In") {
                    Task {
                        try await authViewModel.signIn(email: email, password: password)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(Color(.systemBlue))
                .cornerRadius(12)
                .foregroundColor(.white)
                .padding(.top, 26)
                
                Spacer()
                
                //Register account
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(appColor.grayTextColor)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Register")
                            .font(.system(size: 14, weight: .regular))
                    }
                }
            }
            .toolbar {
                //Navigation Title
                ToolbarItem(placement: .principal) {
                    Text("Sign In")
                        .font(.system(size: 24, weight: .medium))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
