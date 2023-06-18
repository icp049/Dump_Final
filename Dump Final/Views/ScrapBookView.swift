import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ScrapBookView: View {
    @StateObject var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    
    var body: some View {
        VStack {
            Button(action: {
                isShowingNewShoutView = true
            }, label: {
                Text("Upload")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            })
            .padding()
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.retrievedImagePaths, id: \.self) { imagePath in
                        Text(imagePath)
                            .font(.caption)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            retrievePhotos()
        }
        .sheet(isPresented: $isShowingNewShoutView) {
            UploadView(newItemPresented: $isShowingNewShoutView)
        }
    }
    
    func retrievePhotos() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()

        let userRef = db.collection("users").document(userID)
        let imagesRef = userRef.collection("images")

        imagesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving photos: \(error)")
                return
            }

            var paths = [String]()

            for doc in snapshot?.documents ?? [] {
                if let path = doc.data()["url"] as? String {
                    paths.append(path)
                }
            }

            DispatchQueue.main.async {
                viewModel.retrievedImagePaths = paths
            }
        }
    }
}

struct ScrapBookView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookView()
    }
}



