import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct UploadView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var caption = ""
    
    @Binding var newItemPresented: Bool
    @State private var isPosting = false
    
    var isImageSelected: Bool {
        selectedImage != nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isImageSelected {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Select an image")
                }
                
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Choose Image")
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker { image in
                        selectedImage = image
                    }
                }
                
                TextField("Enter caption", text: $caption)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if isImageSelected, let selectedImage = selectedImage {
                        isPosting = true
                        UploadPhoto(image: selectedImage) {
                            newItemPresented = false
                            isPosting = false
                        }
                    }
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(isPosting)
            }
            .padding()
            .navigationBarTitle("Upload")
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var completionHandler: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.completionHandler(uiImage)
            }
            
            picker.dismiss(animated: true)
        }
    }
}

func UploadPhoto(image: UIImage, completion: @escaping () -> Void) {
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
        imageDocumentRef.setData(["url": fileName]) { error in
            if let error = error {
                print("Error adding image URL to user's images collection: \(error)")
            } else {
                print("Image URL added to user's images collection successfully")
            }
            
            completion()
        }
    }
}

func updateUserImageURL(_ imageURL: String, completion: @escaping () -> Void) {
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

struct ContentView_Previews: PreviewProvider {
    @State static var newItemPresented = false
    
    static var previews: some View {
        UploadView(newItemPresented: $newItemPresented)
    }
}

