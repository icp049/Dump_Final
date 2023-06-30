import Foundation
import FirebaseAuth
import FirebaseFirestore

class MainPageShoutViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var username: String = ""
    
    private let appUser: AppUser
    private let db = Firestore.firestore()
    
    @Published var shouts: [Shout] = []
    @Published var rants: [Rant] = []
    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
    
    func fetchShoutsAndRantsFromFollowing() {
        db.collection("following").document(appUser.id).getDocument { [weak self] snapshot, error in
            guard let followingData = snapshot?.data(), error == nil else {
                return
            }
            
            let followingUsers = followingData.compactMap { key, value -> String? in
                if let isFollowing = value as? Bool, isFollowing {
                    return key
                }
                return nil
            }
            
            self?.fetchShoutsAndRants(for: followingUsers)
        }
    }
    
    private func fetchShoutsAndRants(for userIDs: [String]) {
        var shouts: [Shout] = []
        var rants: [Rant] = []
        let dispatchGroup = DispatchGroup()
        
        for userID in userIDs {
            dispatchGroup.enter()
            
            db.collection("shout").whereField("userId", isEqualTo: userID).getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    dispatchGroup.leave()
                    return
                }
                
                let userShouts = documents.compactMap { document -> Shout? in
                    return try? document.data(as: Shout.self)
                }
                
                shouts.append(contentsOf: userShouts)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            
            db.collection("rant").whereField("userId", isEqualTo: userID).getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    dispatchGroup.leave()
                    return
                }
                
                let userRants = documents.compactMap { document -> Rant? in
                    return try? document.data(as: Rant.self)
                }
                
                rants.append(contentsOf: userRants)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.shouts = shouts
            self.rants = rants
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

