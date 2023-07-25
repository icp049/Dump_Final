import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class EditProfileController: ObservableObject {
    @Published var showingNewItemView = false
    @Published var selectedImage: UIImage?
    @Published var name = ""
    @Published var username = ""

    func changeName(newName: String) {
        self.name = newName
    }

    func changeUsername(newUsername: String) {
        self.username = newUsername
    }

    func changeProfileImage(image: UIImage) {
        selectedImage = image
    }

    func saveChanges() {
        guard validate() else {
            return
        }

        // Check if a new profile image has been selected
        if let image = selectedImage {
            UploadProfilePhoto(image: image) { [weak self] imageURL in
                self?.updateUserDataWithImageURL(imageURL: imageURL)
            }
        } else {
            updateUserDataWithImageURL(imageURL: nil)
        }
    }

    private func updateUserDataWithImageURL(imageURL: String?) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user currently logged in.")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        var userData: [String: Any] = [
            "name": name,
            "username": username
        ]

        userRef.updateData(userData) { error in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                print("User updated successfully.")
            }
        }
    }

    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
}

func UploadProfilePhoto(image: UIImage, completion: @escaping (String?) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(nil)
        return
    }

    let storageRef = Storage.storage().reference()

    guard let currentUser = Auth.auth().currentUser else {
        print("No user currently logged in.")
        completion(nil)
        return
    }

    let folderRef = storageRef.child("users/\(currentUser.uid)/profilePhoto")
    
    

    let fileName = "\(UUID().uuidString).jpg"
    let fileRef = folderRef.child(fileName)

    let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
        if let error = error {
            print("Error uploading image: \(error)")
            completion(nil)
            return
        }

        fileRef.downloadURL { url, error in
            if let imageURL = url?.absoluteString {
                completion(imageURL)
            } else {
                completion(nil)
            }
        }
    }

    let db = Firestore.firestore()
    let userRef = db.collection("users").document(currentUser.uid)
    let imageDocumentRef = userRef.collection("profilephoto").document()

    uploadTask.observe(.success) { snapshot in
        imageDocumentRef.setData(["url": fileName, "createdAt": FieldValue.serverTimestamp()]) { error in
            if let error = error {
                print("Error adding image URL and caption to user's images collection: \(error)")
            } else {
                print("Image URL and caption added to user's images collection successfully")
            }

            completion(fileName)
        }
        }
    }


func UpdateProfilePhotoURL(_ imageURL: String, completion: @escaping () -> Void) {
    let db = Firestore.firestore()
    
    guard let currentUser = Auth.auth().currentUser else {
        print("No user currently logged in.")
        return
    }
    
    let userRef = db.collection("users").document(currentUser.uid)
    
    userRef.updateData([
        "imageURL": imageURL
    ]) { error in
        if let error = error {
            print("Error updating user image URL: \(error)")
        } else {
            print("User image URL updated successfully")
        }
        
        completion()
    }
}





