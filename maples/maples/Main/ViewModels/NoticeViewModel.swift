//
//  NoticeViewModel.swift
//  maples
//
//  Created by 김경완 on 10/12/24.
//

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class NoticeViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    private var db = Firestore.firestore()
    
    func fetchNotices() async {
        do {
            let querySnapshot = try await db.collection("notice").getDocuments()
            self.notices = try querySnapshot.documents.compactMap { document in
                try document.data(as: Notice.self)
            }
        } catch {
            print("Error fetching notices: \(error.localizedDescription)")
        }
    }
}
