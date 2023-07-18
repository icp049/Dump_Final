import SwiftUI

struct ScrapBookView: View {
    @StateObject private var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    @State private var isShowingPhotoView = false
    @State private var selectedImage: UIImage?
    
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
                                    .onTapGesture {
                                        isShowingPhotoView = true
                                    }
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
                    Button(action: {
                        isShowingNewShoutView = true
                    }) {
                        Text("Upload")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $isShowingNewShoutView)
            }
            .fullScreenCover(isPresented: $isShowingPhotoView) {
                if let selectedImage = selectedImage {
                    PhotoView(image: selectedImage)
                        .edgesIgnoringSafeArea(.all)
                }
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
}
