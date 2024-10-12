//
//  ProfileViewModel.swift
//  maples
//
//  Created by 김경완 on 10/11/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Combine

class AccountViewModel: ObservableObject {
    // View를 업데이트하기 위한 Published 속성들
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var profileImage: UIImage? = nil
    @Published var uploadProgress: Double = 0.0
    @Published var profileImageUrl: String? = nil
    @Published var errorMessage: String? = nil
    @Published var isUploading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadProfile()
    }

    // Firestore에서 기존 프로필 이미지 URL 로드
    func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { [weak self] document, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "프로필 로드 실패: \(error.localizedDescription)"
                }
                return
            }

            if let document = document, document.exists {
                DispatchQueue.main.async {
                    self?.profileImageUrl = document.get("profileImageUrl") as? String
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "사용자 프로필이 존재하지 않습니다."
                }
            }
        }
    }

    // 이미지 선택 및 업로드 처리
    func handleImageSelection() {
        guard !selectedPhotos.isEmpty else { return }
        let item = selectedPhotos.first!

        item.loadTransferable(type: Data.self) { [weak self] result in
            switch result {
            case .success(let data?):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImage = image
                        self?.uploadImage(image: image)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "데이터를 이미지로 변환하지 못했습니다."
                    }
                }
            case .success(nil):
                DispatchQueue.main.async {
                    self?.errorMessage = "이미지 데이터를 찾을 수 없습니다."
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = "이미지 로드 실패: \(error.localizedDescription)"
                }
            }
        }
    }

    // Firebase Storage에 이미지 업로드 및 Firestore 업데이트
    private func uploadImage(image: UIImage) {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "사용자가 인증되지 않았습니다."
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            self.errorMessage = "이미지 압축 실패."
            return
        }

        isUploading = true
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_images/\(user.uid).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = storageRef.putData(imageData, metadata: metadata)

        // 업로드 진행 상태 관찰
        uploadTask.observe(.progress) { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.uploadProgress = Double(snapshot.progress?.fractionCompleted ?? 0)
            }
        }

        // 업로드 완료 처리
        uploadTask.observe(.success) { [weak self] snapshot in
            storageRef.downloadURL { url, error in
                DispatchQueue.main.async {
                    self?.isUploading = false
                }
                if let error = error {
                    DispatchQueue.main.async {
                        self?.errorMessage = "다운로드 URL 가져오기 실패: \(error.localizedDescription)"
                    }
                    return
                }

                if let url = url {
                    self?.saveImageUrlToFirestore(url: url.absoluteString)
                }
            }
        }

        // 업로드 실패 처리
        uploadTask.observe(.failure) { [weak self] snapshot in
            if let error = snapshot.error {
                DispatchQueue.main.async {
                    self?.isUploading = false
                    self?.errorMessage = "이미지 업로드 실패: \(error.localizedDescription)"
                }
            }
        }
    }

    // Firestore에 이미지 URL 저장
    private func saveImageUrlToFirestore(url: String) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.uid)

        userDoc.setData(["profileImageUrl": url], merge: true) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "URL 저장 실패: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    self?.profileImageUrl = url
                }
            }
        }
    }
}
