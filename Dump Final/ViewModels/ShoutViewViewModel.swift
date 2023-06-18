import Foundation
import FirebaseAuth
import FirebaseFirestore

class ShoutViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var username: String = ""
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    @Published var user: User? = nil
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(id: data["id"] as? String ?? "",
                                  name: data["name"] as? String ?? "",
                                  username: data["username"] as? String ?? "",
                                  email: data["email"] as? String ?? "")
                
                self?.username = data["username"] as? String ?? "" // Set the username value
            }
        }
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        
        // Delete from the "shout" collection
        db.collection("users")
            .document(userId)
            .collection("shout")
            .document(id)
            .delete()

        // Delete from the "rant" collection
        db.collection("users")
            .document(userId)
            .collection("rant")
            .document(id)
            .delete()
    }
}

func formatDate(_ timeInterval: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

