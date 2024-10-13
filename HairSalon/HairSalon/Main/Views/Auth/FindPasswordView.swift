//
//  FindPasswordView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct FindPasswordView: View {
    //Import Files
    private let appColor = AppColor()
    
    //State Properties
    @State private var email: String = ""
    
    var body: some View {
        VStack {
            Text("Enter the email address associate with your account and\nwe will send an email with a code to reset your password.")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(appColor.grayTextColor)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.system(size: 16, weight: .regular))
                
                TextField("Enter your emaill adress", text: $email)
            }
            .padding(.top, 40)
            
            //Sign In Button
            Button("Send Email") {
                
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color(.systemBlue))
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.top, 26)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Find Password")
                    .font(.system(size: 24, weight: .medium))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }
}

#Preview {
    FindPasswordView()
}
