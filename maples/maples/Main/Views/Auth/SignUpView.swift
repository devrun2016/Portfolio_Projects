//
//  SignUpView.swift
//  maples
//
//  Created by 김경완 on 10/10/24.
//

import SwiftUI
import Combine

struct SignUpView: View {
    //View Models
    @EnvironmentObject var authViewModel: AuthViewModel
    
    //State Properties
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MAPLES")
                .font(.system(size: 26))
                .fontWeight(.black)
                .padding(.bottom, 24)
            
            Text("회원 가입")
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            Text("커뮤니티에 가입을 해주시는 이용자분께 감사를 드리며\n플랫폼을 통해 즐거운 시간을 보내시길 바랍니다.")
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
                
                //Confirm Password
                Text("비밀번호 확인")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "lock.rectangle.fill")
                        .foregroundColor(Color(.systemGray3))
                    
                    SecureField("비밀번호를 확인해주세요", text: $authViewModel.confirmPassword)
                        .textInputAutocapitalization(.never)
                }
                .padding(4)
                .overlay {
                    Rectangle()
                        .stroke(Color(.systemGray3), lineWidth: 2)
                }
                .padding(.bottom, 4)
                
                //Profile Name
                Text("닉네임")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                HStack {
                    Image(systemName: "person.text.rectangle")
                        .foregroundColor(Color(.systemGray3))
                    
                    TextField("닉네임을 입력해주세요.", text: $authViewModel.nickName)
                        .textInputAutocapitalization(.never)
                }
                .padding(4)
                .overlay {
                    Rectangle()
                        .stroke(Color(.systemGray3), lineWidth: 2)
                }
                .padding(.bottom)
                
                Text(authViewModel.vaildateMessage ?? "")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Text("회원가입을 완료하면 개인정보 이용 약관에 동의한 것으로 간주됩니다.\n제3자에게 정보 제공을 하지 않습니다.")
                .font(.caption)
                .multilineTextAlignment(.center)

            
            Spacer()
            
            Button("회원가입") {
                let isEmailValid = authViewModel.emailValidation(email: authViewModel.email)
                let isPasswordValid = authViewModel.passwordValidation(password: authViewModel.password)
                
                guard isEmailValid else {
                    authViewModel.vaildateMessage = "이메일을 잘 못 입력하셨습니다."
                    return
                }

                guard isPasswordValid else {
                    authViewModel.vaildateMessage = "비밀번호는 대문자,소문자,숫자,특수문자 최소 1개 이상인 8자리여야 합니다."
                    return
                }

                guard authViewModel.password == authViewModel.confirmPassword, !authViewModel.password.isEmpty else {
                    authViewModel.vaildateMessage = "비밀번호가 일치하지 않거나 또는 비밀번호를 입력하지 않았습니다."
                    return
                }

                guard !authViewModel.nickName.isEmpty else {
                    authViewModel.vaildateMessage = "닉네임을 입력하지 않았습니다."
                    return
                }
                
                Task {
                    try await authViewModel.createUser(email: authViewModel.email, password: authViewModel.password, nickName: authViewModel.nickName)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(.black)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
            .padding(.bottom)
        }
        .padding()
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
