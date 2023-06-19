import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ScrapBookView: View {
    @StateObject var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    
    var body: some View {
        VStack {
            RUButton(title: "Upload", background: .green) {
                isShowingNewShoutView = true
            }
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $isShowingNewShoutView)
            }
            .padding()
            
            Divider()
            
            ScrollView {
                LazyVGrid(columns: gridLayout, spacing: 20) {
                    ForEach(viewModel.retrievedImages.reversed(), id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
    }
    
    private let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    func retrievePhotos() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        
        let userRef = db.collection("users").document(userID)
        
        userRef.collection("images").getDocuments { snapshot, error in
            if let error = error {
                print("Error retrieving photos: \(error)")
                return
            }
            
            var paths = [String]()
            
            for doc in snapshot?.documents ?? [] {
                if let fileName = doc["url"] as? String {
                    let imagePath = "users/\(userID)/images/\(fileName)"
                    paths.append(imagePath)
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

