import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class MainPageShoutViewViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var followingUserIDs: [String] = []
    @Published var currentUserRants: [String] = []
    @Published var followingUserRants: [String] = []
    
    init() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // Handle the case when the current user is not authenticated
            print("Current user not authenticated")
            return
        }
        
        // Fetch the current user's rants
        let currentUserRantsQuery = self.db.collection("users").document(currentUserID).collection("rant")
        
        currentUserRantsQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error getting current user's rant collection: \(error)")
                return
            }
            
            guard let rantDocuments = querySnapshot?.documents else {
                // No rants found for the current user
                return
            }
            
            // Iterate over each rant document and retrieve the rant strings
            let rantStrings = rantDocuments.compactMap { document -> String? in
                let rantData = document.data()
                let rantString = rantData["rant"] as? String
                return rantString
            }
            
            DispatchQueue.main.async {
                self.currentUserRants = rantStrings
            }
        }
        
        // Query the "following" collection of the current user to get all the users they are following
        let followingRef = db.collection("users").document(currentUserID).collection("following")
        
        followingRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error getting following collection: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                // No following users found
                print("No following users found")
                return
            }
            
            // Iterate over each document in the "following" collection
            for document in documents {
                let followingUserID = document.documentID
                self.followingUserIDs.append(followingUserID)
            }
            
            print("Following User IDs: \(self.followingUserIDs)")
            
            // Retrieve the rant collection for all the following users
            for userID in self.followingUserIDs {
                let rantQuery = self.db.collection("users").document(userID).collection("rant")
                
                rantQuery.getDocuments { (rantQuerySnapshot, rantError) in
                    if let rantError = rantError {
                        // Handle the error
                        print("Error getting rant collection for user \(userID): \(rantError)")
                        return
                    }
                    
                    guard let rantDocuments = rantQuerySnapshot?.documents else {
                        // No rants found for the user
                        return
                    }
                    
                    // Iterate over each rant document and retrieve the rant strings
                    let rantStrings = rantDocuments.compactMap { document -> String? in
                        let rantData = document.data()
                        let rantString = rantData["rant"] as? String
                        return rantString
                    }
                    
                    DispatchQueue.main.async {
                        self.followingUserRants.append(contentsOf: rantStrings)
                    }
                }
            }
        }
    }
}

