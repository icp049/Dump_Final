import SwiftUI

struct MainPageShoutView: View {
    @ObservedObject var viewModel = MainPageShoutViewViewModel()

    var body: some View {
        VStack {
            Text("Rants:")
                .font(.headline)

            if viewModel.currentUserRants.isEmpty && viewModel.followingUserRants.isEmpty {
                Text("No rants found.")
                    .foregroundColor(.gray)
            } else {
                List {
                    Section(header: Text("My Rants")) {
                        ForEach(viewModel.currentUserRants, id: \.self) { rant in
                            Text(rant)
                        }
                    }
                    
                    Section(header: Text("Following User Rants")) {
                        ForEach(viewModel.followingUserRants, id: \.self) { rant in
                            Text(rant)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct MainPageShoutView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageShoutView()
    }
}

