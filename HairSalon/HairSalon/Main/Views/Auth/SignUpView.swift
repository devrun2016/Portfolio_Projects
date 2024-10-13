//
//  SignUpView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct SignUpView: View {
    //Imported ViewModels
    @EnvironmentObject var viewModel: AuthViewModel
    
    //Import Files
    private let appColor = AppColor()
    
    //State Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
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
                
                Text("Password")
                    .font(.system(size: 16, weight: .regular))
                
                SecureField("Enter your password", text: $password)
                    .padding(.bottom)
                
                Text("Confirm Password")
                    .font(.system(size: 16, weight: .regular))
                
                SecureField("Re-Enter your password", text: $confirmPassword)
            }
            .padding(.top, 40)
             
            //Sign In Button
            Button("Sign Up") {
                Task {
                    //Create User But need to create validation!!!!
                    try await AuthViewModel().createUser(email: email, password: password, nickName: "welcome", profileImageURL: "person.crop.circle.fill")
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
