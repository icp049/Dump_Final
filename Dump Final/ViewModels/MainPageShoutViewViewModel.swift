import Foundation
import FirebaseFirestore

class MainPageShoutViewViewModel: ObservableObject {
    private let db = Firestore.firestore()
    private let appUser: AppUser
    
    @Published var shouts: [Shout] = []
    @Published var rants: [Rant] = []
    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
    
    func fetchUser() {
        db.collection("users").document(appUser.id).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Fetch any necessary user data if needed
            }
        }
    }
    
    func fetchShoutsAndRants() {
        let followingQuery = db.collection("users").document(appUser.id).collection("following")
        
        followingQuery.getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }
            
            let followingUserIds = documents.compactMap { $0.documentID }
            
            let shoutsQuery = self?.db.collection("shouts").whereField("userId", in: followingUserIds)
            let rantsQuery = self?.db.collection("rants").whereField("userId", in: followingUserIds)
            
            shoutsQuery?.getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    return
                }
                
                let shouts = documents.compactMap { document -> Shout? in
                    return try? document.data(as: Shout.self)
                }
                
                DispatchQueue.main.async {
                    self?.shouts = shouts
                }
            }
            
            rantsQuery?.getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    return
                }
                
                let rants = documents.compactMap { document -> Rant? in
                    return try? document.data(as: Rant.self)
                }
                
                DispatchQueue.main.async {
                    self?.rants = rants
                }
            }
        }
    }
    
    func formatDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

