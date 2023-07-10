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
                var retrievedImages = [UIImage]() // Temporarily store retrieved images

                for doc in documents {
                    if let fileName = doc["url"] as? String {
                        let imagePath = "users/\(userID)/images/\(fileName)"

                        if uniquePaths.contains(imagePath) {
                            continue // Skip duplicate image paths
                        }
                        uniquePaths.insert(imagePath)

                        let fileRef = storageRef.child(imagePath)

                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if let error = error {
                                print("Error retrieving photo data: \(error)")
                                return
                            }

                            if let data = data, let image = UIImage(data: data) {
                                retrievedImages.append(image) // Store retrieved image
                            }

                            // Check if all images have been retrieved
                            if retrievedImages.count == uniquePaths.count {
                                DispatchQueue.main.async {
                                    // Sort the retrieved images by createdAt field in descending order
                                    let sortedImages = retrievedImages.sorted { (image1, image2) -> Bool in
                                        guard let timestamp1 = (doc["createdAt"] as? Timestamp)?.dateValue(),
                                              let timestamp2 = (doc["createdAt"] as? Timestamp)?.dateValue()
                                        else {
                                            return false
                                        }

                                        return timestamp1 > timestamp2
                                    }

                                    self.retrievedImages = sortedImages // Update published property
                                }
                            }
                        }
                    }
                }
            }
    }
}

