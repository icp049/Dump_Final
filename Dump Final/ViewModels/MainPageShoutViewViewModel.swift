import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainPageShoutViewViewModel: ObservableObject {
    @Published var followingPosts: [PostWrapper] = []
    
    private var followingPostsListener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    func fetchFollowingPosts(forUserID userID: String) {
        followingPostsListener = db.collection("users").document(userID).collection("following").addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching following collection: \(error?.localizedDescription ?? "")")
                return
            }
            
            var combinedPosts: [PostWrapper] = []
            
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
                dispatchGroup.enter()
                let followedUserID = document.documentID
                
                let shoutPostsQuery = self?.db.collection("users").document(followedUserID).collection("shout")
                let rantPostsQuery = self?.db.collection("users").document(followedUserID).collection("rant")
                let mehPostsQuery = self?.db.collection("users").document(followedUserID).collection("meh")
                
                let fetchPostsGroup = DispatchGroup()
                
                var shoutPosts: [Shout] = []
                var rantPosts: [Rant] = []
                var mehPosts: [Meh] = []
                
                fetchPostsGroup.enter()
                shoutPostsQuery?.getDocuments { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        shoutPosts = documents.compactMap { document in
                            try? document.data(as: Shout.self)
                        }
                    }
                    fetchPostsGroup.leave()
                }
                
                fetchPostsGroup.enter()
                rantPostsQuery?.getDocuments { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        rantPosts = documents.compactMap { document in
                            try? document.data(as: Rant.self)
                        }
                    }
                    fetchPostsGroup.leave()
                }
                
                fetchPostsGroup.enter()
                mehPostsQuery?.getDocuments { querySnapshot, error in
                    if let documents = querySnapshot?.documents {
                        mehPosts = documents.compactMap { document in
                            try? document.data(as: Meh.self)
                        }
                    }
                    fetchPostsGroup.leave()
                }
                
                fetchPostsGroup.notify(queue: .main) {
                    let shoutPostsWrappers = shoutPosts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false, isMeh: false) }
                    let rantPostsWrappers = rantPosts.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant: true, isMeh: false) }
                    let mehPostsWrappers = mehPosts.map { PostWrapper(id: $0.id, content: $0.meh, postDate: $0.postDate, isRant: false, isMeh: true) }
                    
                    combinedPosts += shoutPostsWrappers + rantPostsWrappers + mehPostsWrappers
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self?.followingPosts = combinedPosts.sorted { $0.postDate > $1.postDate }
            }
        }
    }
    
    deinit {
        followingPostsListener?.remove()
    }
}

