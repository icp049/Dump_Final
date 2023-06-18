import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewShoutViewViewModel: ObservableObject {
    @Published var shout = ""
    @Published var rant = ""
    @Published var shoutDate = Date()
    @Published var rantDate = Date()
    
    init() {}
    
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
                             postTime: Date().timeIntervalSince1970
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
                            postTime: Date().timeIntervalSince1970
        )
        
        // Save model to database
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("rant")
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

