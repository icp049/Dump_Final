import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ScrapBookView: View {
    @StateObject var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        LazyVGrid(columns: gridLayout(geometry.size), spacing: 2) {
                            ForEach(viewModel.retrievedImages.reversed(), id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width / 3 - 1, height: geometry.size.width / 3 - 1)
                                    .clipped()
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(2)
                }
            }
            .navigationTitle("Scrapbook")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    RUButton(title: "Upload", background: .green) {
                        isShowingNewShoutView = true
                    }
                }
            }
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $isShowingNewShoutView)
            }
            .onAppear {
                retrievePhotos()
            }
        }
    }
    
    private func gridLayout(_ size: CGSize) -> [GridItem] {
        let columns: Int = {
            if size.width < 400 {
                return 3
            } else if size.width < 600 {
                return 4
            } else {
                return 5
            }
        }()
        
        return Array(repeating: .init(.flexible()), count: columns)
    }
    
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

