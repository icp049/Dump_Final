import Foundation
import FirebaseAuth
import FirebaseFirestore


class MainPageShoutViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var username: String = ""
    var followingUsers: [AppUser] = []
    
    private let appUser: AppUser
    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
    
    @Published var user: AppUser? = nil
    
    func fetchFollowingUsers(for userID: String) {
        let db = Firestore.firestore()
        db.collection("following").whereField("followerId", isEqualTo: userID).getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }

            var followingUsers: [AppUser] = []

            let dispatchGroup = DispatchGroup()

            for document in documents {
                let data = document.data()
                let followedUserID = data["userId"] as? String ?? ""
                
                dispatchGroup.enter()
                db.collection("users").document(followedUserID).getDocument { snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let data = snapshot?.data(), error == nil else {
                        return
                    }
                    
                    let user = AppUser(id: data["id"] as? String ?? "",
                                       name: data["name"] as? String ?? "")
                    followingUsers.append(user)
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self?.followingUsers = followingUsers
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


