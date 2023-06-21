import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserShoutViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var username: String = ""
    
    private let appUser: AppUser
    
    init(appUser: AppUser) {
        self.appUser = appUser
    }
    
    @Published var user: AppUser? = nil
    
    func fetchUser() {
        let db = Firestore.firestore()
        db.collection("users").document(appUser.id).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = AppUser(id: data["id"] as? String ?? "",
                                     name: data["name"] as? String ?? "")
                
                
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

