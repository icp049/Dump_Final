import SwiftUI

struct ScrapBookView: View {
    @StateObject var viewModel = ScrapBookViewViewModel()
    @State private var isShowingNewShoutView = false
    
    
    var body: some View {
        VStack {
            RUButton(title:"Upload", background: .green){
                isShowingNewShoutView = true
            }
            .sheet(isPresented: $isShowingNewShoutView) {
                UploadView(newItemPresented: $viewModel.showingNewItemView)
            
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

