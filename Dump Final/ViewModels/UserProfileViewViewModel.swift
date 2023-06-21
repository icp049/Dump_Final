import Foundation
import FirebaseFirestore

class UserProfileViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func followUser(userId: String, currentUserId: String) {
        let currentUserFollowingRef = db.collection("users").document(currentUserId).collection("following").document(userId)
        
        currentUserFollowingRef.setData(["userId": userId]) { error in
            if let error = error {
                // Handle the error
                print("Error following user: \(error.localizedDescription)")
            } else {
                // Follow action completed successfully
                print("Successfully followed user!")
            }
        }
    }
}
