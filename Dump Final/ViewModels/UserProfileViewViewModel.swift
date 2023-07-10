import Foundation
import FirebaseFirestore

class UserProfileViewModel: ObservableObject {
    private let db = Firestore.firestore()
    
    func followUser(userId: String, currentUserId: String) {
        let currentUserFollowingRef = db.collection("users").document(currentUserId).collection("following").document(userId)
        let followedUserFollowersRef = db.collection("users").document(userId).collection("followers").document(currentUserId)
        
        currentUserFollowingRef.getDocument { snapshot, error in
            if let error = error {
                // Handle the error
                print("Error checking following status: \(error.localizedDescription)")
                return
            }
            
            if snapshot?.exists == true {
                // User is already following
                print("User is already following.")
                return
            }
            
            // User is not following, so follow them
            currentUserFollowingRef.setData(["userId": userId]) { error in
                if let error = error {
                    // Handle the error
                    print("Error following user: \(error.localizedDescription)")
                } else {
                    // Follow action completed successfully
                    print("Successfully followed user!")
                    
                    // Add current user to the follower list of the user being followed
                    followedUserFollowersRef.setData(["followerId": currentUserId]) { error in
                        if let error = error {
                            // Handle the error
                            print("Error adding follower: \(error.localizedDescription)")
                        } else {
                            // Follower added successfully
                            print("Successfully added follower!")
                        }
                    }
                }
            }
        }
    }
    
    func unfollowUser(userId: String, currentUserId: String) {
        let currentUserFollowingRef = db.collection("users").document(currentUserId).collection("following").document(userId)
        let followedUserFollowersRef = db.collection("users").document(userId).collection("followers").document(currentUserId)
        
        currentUserFollowingRef.getDocument { snapshot, error in
            if let error = error {
                // Handle the error
                print("Error checking following status: \(error.localizedDescription)")
                return
            }
            
            if snapshot?.exists == true {
                // User is following, so unfollow them
                currentUserFollowingRef.delete { error in
                    if let error = error {
                        // Handle the error
                        print("Error unfollowing user: \(error.localizedDescription)")
                    } else {
                        // Unfollow action completed successfully
                        print("Successfully unfollowed user!")
                    }
                }
                
                // Remove current user from the follower list of the user being unfollowed
                followedUserFollowersRef.delete { error in
                    if let error = error {
                        // Handle the error
                        print("Error removing follower: \(error.localizedDescription)")
                    } else {
                        // Follower removed successfully
                        print("Successfully removed follower!")
                    }
                }
            } else {
                // User is not following
                print("User is not following.")
                return
            }
        }
    }
}

