//
//  EditProfileController.swift
//  Dump Final
//
//  Created by Ian Pedeglorio on 2023-07-16.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import FirebaseFirestore

class EditProfileController: ObservableObject {
    @Published var showingNewItemView = false
    @State private var selectedImage: UIImage?
}





func UploadProfilePhoto(image: UIImage, completion: @escaping () -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        return
    }
    
    let storageRef = Storage.storage().reference()
    
    guard let currentUser = Auth.auth().currentUser else {
        print("No user currently logged in.")
        return
    }
    
    let folderRef = storageRef.child("users/\(currentUser.uid)/images")
    
    let fileName = "\(UUID().uuidString).jpg"
    let fileRef = folderRef.child(fileName)
    
    let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
        if let error = error {
            print("Error uploading image: \(error)")
            return
        }
        
        fileRef.downloadURL { url, error in
            if let imageURL = url?.absoluteString {
                updateUserImageURL(imageURL) {
                    completion()
                }
            }
        }
    }
    
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(currentUser.uid)
    let imageDocumentRef = userRef.collection("images").document() // Create a new document inside the "images" collection
    
    uploadTask.observe(.success) { snapshot in
        imageDocumentRef.setData(["url": fileName, "createdAt": FieldValue.serverTimestamp()]){ error in
            if let error = error {
                print("Error adding image URL to user's images collection: \(error)")
            } else {
                print("Image URL added to user's images collection successfully")
            }
            
            completion()
        }
    }
}

func updateUserProfileImageURL(_ imageURL: String, completion: @escaping () -> Void) {
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