//
//  SignInView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI

struct SignInView: View {
    //View Models
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("MAPLES")
                    .font(.system(size: 26))
                    .fontWeight(.black)
                    .padding(.bottom, 24)
                
                Text("로그인")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                
                Text("커뮤니티에 접속하려면 로그인은 필수 입니다.\n플랫폼을 통해 즐거운 시간을 보내시길 바랍니다.")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading) {
                    //Email
                    Text("이메일")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color(.systemGray3))
                        
                        TextField("이메일을 입력해주세요", text: $authViewModel.email)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(4)
                    .overlay {
                        Rectangle()
                            .stroke(Color(.systemGray3), lineWidth: 2)
                    }
                    .padding(.bottom, 4)
                    
                    //password
                    Text("비밀번호")
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "lock.rectangle.fill")
                            .foregroundColor(Color(.systemGray3))
                        
                        SecureField("비밀번호를 입력해주세요", text: $authViewModel.password)
                            .textInputAutocapitalization(.never)
                    }
                    .padding(4)
                    .overlay {
                        Rectangle()
                            .stroke(Color(.systemGray3), lineWidth: 2)
                    }
                    .padding(.bottom, 4)
                    
                    //Error Message
                    Text(authViewModel.vaildateMessage ?? "")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.bottom, 100)
                
                Button("로그인") {
                    let isEmailValid = authViewModel.emailValidation(email: authViewModel.email)
                    let isPasswordValid = authViewModel.passwordValidation(password: authViewModel.password)
                    
                    guard isEmailValid else {
                        authViewModel.vaildateMessage = "이메일을 잘 못 입력하셨습니다."
                        return
                    }

                    guard isPasswordValid else {
                        authViewModel.vaildateMessage = "비밀번호를 잘 못 입력하셨습니다."
                        return
                    }

                    Task {
                        try await authViewModel.signInUser(email: authViewModel.email, password: authViewModel.password)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(.black)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 40)
                
                HStack {
                    Text("계정이 없으신가요? ")
                        .font(.caption)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("회원가입")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthViewModel())
}
