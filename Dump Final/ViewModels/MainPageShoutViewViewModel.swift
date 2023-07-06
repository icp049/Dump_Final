import Foundation
import FirebaseAuth
import FirebaseFirestore


class MainPageShoutViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var username: String = ""
    var followingUsers: [MyAppUser] = []
    
    private let appUser: MyAppUser
    
    init(appUser: MyAppUser) {
        self.appUser = appUser
    }
    
    @Published var user: MyAppUser? = nil
    
    func fetchFollowingUsers(for userID: String) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()

        db.collection("following").whereField("userId", isEqualTo: userID).getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }
            
            var followingUsers: [MyAppUser] = []

            for document in documents {
                let data = document.data()
                let followedUserID = data["userId"] as? String ?? ""
                var user = MyAppUser(id: followedUserID, name: "")

                dispatchGroup.enter()
                let shoutsQuery = db.collection("users/\(followedUserID)/shout")
                let rantsQuery = db.collection("users/\(followedUserID)/rant")
                let mehsQuery = db.collection("users/\(followedUserID)/meh")

                // Fetch shouts
                dispatchGroup.enter()
                shoutsQuery.getDocuments { [weak self] snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let documents = snapshot?.documents, error == nil else {
                        return
                    }
                    
                    user.shouts = documents.compactMap { document in
                        try? document.data(as: Shout.self)
                    }
                }
                
                // Fetch rants
                dispatchGroup.enter()
                rantsQuery.getDocuments { [weak self] snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let documents = snapshot?.documents, error == nil else {
                        return
                    }
                    
                    user.rants = documents.compactMap { document in
                        try? document.data(as: Rant.self)
                    }
                }
                
                // Fetch mehs
                dispatchGroup.enter()
                mehsQuery.getDocuments { [weak self] snapshot, error in
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    guard let documents = snapshot?.documents, error == nil else {
                        return
                    }
                    
                    user.mehs = documents.compactMap { document in
                        try? document.data(as: Meh.self)
                    }
                }
                
                followingUsers.append(user)
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


