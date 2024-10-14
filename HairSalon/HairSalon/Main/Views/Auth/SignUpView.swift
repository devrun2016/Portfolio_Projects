//
//  SignUpView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct SignUpView: View {
    //Imported ViewModels
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //Import Files
    private let appColor = AppColor()
    
    //State Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var userName: String = ""
    
    @State private var isEmailValid: Bool = false
    
    var body: some View {
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
                
                Text("User name")
                    .font(.system(size: 16, weight: .regular))
                
                TextField("Enter your user name", text: $userName)
                    .padding(.bottom)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                Text("Password")
                    .font(.system(size: 16, weight: .regular))
                
                SecureField("Enter your password", text: $password)
                    .padding(.bottom)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                Text("Confirm Password")
                    .font(.system(size: 16, weight: .regular))
                
                SecureField("Re-Enter your password", text: $confirmPassword)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
            .padding(.top, 40)
            
            Text("\(authViewModel.validationError)")
                .font(.caption)
                .foregroundColor(.red)
             
            //Sign In Button
            Button("Sign Up") {
                guard password == confirmPassword else {
                    authViewModel.validationError = "Password does not match"
                    return
                }
                
                Task {
                    try await authViewModel.createUser(email: email, password: password, userName: userName)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(.systemBlue))
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.top, 26)
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Sign Up")
                    .font(.system(size: 24, weight: .medium))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
