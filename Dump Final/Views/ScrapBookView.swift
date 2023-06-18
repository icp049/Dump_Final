import SwiftUI

struct ScrapBookView: View {
    @StateObject var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    
    var body: some View {
        VStack {
            RUButton(title: "Upload", background: .green) {
                isShowingNewShoutView = true
            }
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $viewModel.showingNewItemView)
            }
            
            if let photos = viewModel.photos {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(photos, id: \.id) { photo in
                        Image(uiImage: photo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                    }
                }
                .padding(.horizontal)
            } else {
                ProgressView() // Show a loading indicator while photos are being fetched
            }
        }
        .padding()
    }
}

struct ScrapBookView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapBookView()
    }
}

