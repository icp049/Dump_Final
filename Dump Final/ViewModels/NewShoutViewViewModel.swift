import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewShoutViewViewModel: ObservableObject {
    @Published var shout = ""
    @Published var rant = ""
    @Published var meh = ""
    @Published var shoutDate = Date()
    @Published var rantDate = Date()
    var username = "" // Add a property to store the username
    
    init() {
        
        fetchUsername()
    }
    
    private func fetchUsername() {
            guard let uId = Auth.auth().currentUser?.uid else {
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users").document(uId).getDocument { snapshot, error in
                if let error = error {
                    print("Error getting user document: \(error.localizedDescription)")
                    return
                }
                
                if let data = snapshot?.data(), let username = data["username"] as? String {
                    self.username = username
                }
            }
        }
    
    func saveShout() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = Shouts(id: newId,
                             shout: shout,
                             postDate: Date().timeIntervalSince1970,
                             postTime: Date().timeIntervalSince1970,
                             postedBy: username
                            
        )
        
        // Save model to database
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("shout")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    func saveRant() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = Rants(id: newId,
                            rant: shout,
                            postDate: Date().timeIntervalSince1970,
                            postTime: Date().timeIntervalSince1970,
                            postedBy: username
                        
        )
        
        // Save model to database
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("rant")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    
    func saveMeh() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = Mehs(id: newId,
                            meh: shout,
                            postDate: Date().timeIntervalSince1970,
                            postTime: Date().timeIntervalSince1970,
                            postedBy: username
                          
                           
        )
        
        // Save model to database
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("meh")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        guard !shout.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        return true
    }
}

