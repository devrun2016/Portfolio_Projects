//
//  AccountView.swift
//  HairSalon
//
//  Created by 김경완 on 10/13/24.
//

import SwiftUI

struct AccountView: View {
    //Import Files
    private let appColor = AppColor()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Account")
                    .font(.system(size: 20, weight: .medium))
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88)
                    .foregroundColor(appColor.darkGray)
                
                Text("Emmie Watson")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(appColor.textBlack)
                
                Text("emmie@gmail.com")
                    .font(.system(size: 14, weight: .regular))
                    .tint(appColor.grayTextColor)
                    .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Section("My Account") {
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    
                                Text("Personal Information")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            }
                            .foregroundColor(appColor.textBlack)
                        }
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                        
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image(systemName: "person.badge.key")
                                    
                                Text("Privacy Policy")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            }
                            .foregroundColor(appColor.textBlack)
                        }
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                    }
                    .font(.system(size: 16, weight: .semibold))
                    
                    VStack {
                        
                    }
                    .padding(.vertical, 10)
                    
                    Section("More") {
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    
                                Text("Help Center")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            }
                            .foregroundColor(appColor.textBlack)
                        }
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    
                                Text("Sign Out")
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            }
                            .foregroundColor(.red)
                        }
                        .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0))
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
                
                Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
        }
    }
}

#Preview {
    AccountView()
}
