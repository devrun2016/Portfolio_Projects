//
//  ProfileImageView.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ProfileImageView: View {
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        // 업로드 진행 상태 표시
        if viewModel.isUploading {
            ProgressView(value: viewModel.uploadProgress)
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal)
        }
        
        // 에러 메시지 표시
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        
        ZStack {
            if let profileImageUrl = viewModel.profileImageUrl, let url = URL(string: profileImageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }   else if let profileImage = viewModel.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
            
            PhotosPicker(selection: $viewModel.selectedPhotos, maxSelectionCount: 1, matching: .images) {
                Image(systemName: "pencil.circle.fill")
                    .foregroundColor(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .onAppear {
                viewModel.handleImageSelection()
            }
            .offset(x: 40, y: 40)
            
        }
    }
}

#Preview {
    ProfileImageView()
}
