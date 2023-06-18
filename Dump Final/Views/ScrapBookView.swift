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
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $isShowingNewShoutView)
            }
            .padding()
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(viewModel.retrievedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            retrievePhotos()
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
            
            for path in paths {
                let fileRef = storageRef.child(path)
                
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error retrieving photo data: \(error)")
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            viewModel.retrievedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}

struct ScrapBookView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookView()
    }
}

