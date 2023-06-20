import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Combine

class ScrapBookViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var retrievedImagePaths: [String] = []
    @Published var retrievedImages: [UIImage] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        retrievePhotos()
    }
    
    func retrievePhotos() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        
        let userRef = db.collection("users").document(userID)
        
        userRef.collection("images")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error retrieving photos: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                var uniquePaths = Set<String>() // Track unique image paths
                
                for doc in documents {
                    if let fileName = doc["url"] as? String {
                        let imagePath = "users/\(userID)/images/\(fileName)"
                        if uniquePaths.contains(imagePath) {
                            continue // Skip duplicate image paths
                        }
                        uniquePaths.insert(imagePath)
                        
                        let fileRef = storageRef.child(imagePath)
                        
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
                            guard let self = self else { return }
                            
                            if let error = error {
                                print("Error retrieving photo data: \(error)")
                                return
                            }
                            
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    if !self.retrievedImages.contains(image) {
                                        self.retrievedImages.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }

}

