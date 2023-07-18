import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Combine

class ScrapBookViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var retrievedImages: [UIImage] = []

    struct ImageWithTimestamp {
        let image: UIImage
        let timestamp: String
    }

    @Published var retrievedImageTimestamps: [ImageWithTimestamp] = []

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
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error retrieving photos: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents found")
                    return
                }

                let dispatchGroup = DispatchGroup()
                var retrievedImages = [UIImage]()
                var retrievedImageTimestamps = [ImageWithTimestamp]()

                for doc in documents {
                    if let fileName = doc["url"] as? String {
                        let imagePath = "users/\(userID)/images/\(fileName)"

                        let fileRef = storageRef.child(imagePath)

                        dispatchGroup.enter()
                        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                            if let error = error {
                                print("Error retrieving photo data: \(error)")
                                dispatchGroup.leave()
                                return
                            }

                            if let data = data, let image = UIImage(data: data) {
                                retrievedImages.append(image)

                                if let createdAt = doc["createdAt"] as? Timestamp {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    let timestampString = formatter.string(from: createdAt.dateValue())

                                    let imageWithTimestamp = ImageWithTimestamp(image: image, timestamp: timestampString)
                                    retrievedImageTimestamps.append(imageWithTimestamp)
                                }
                            }

                            dispatchGroup.leave()
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.retrievedImageTimestamps = retrievedImageTimestamps

                    // Sort the retrieved images by createdAt field in descending order
                    let sortedImages = retrievedImageTimestamps
                        .sorted { $0.timestamp > $1.timestamp }
                        .map { $0.image }

                    self.retrievedImages = sortedImages
                }
            }
    }
}

