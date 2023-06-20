import SwiftUI
import Firebase

struct AppUser: Identifiable {
    let id: String
    let name: String
    // Add other properties you want to display
}

class UserViewModel: ObservableObject {
    @Published var appUsers: [AppUser] = []
    
    func fetchAppUsers() {
        
        let appUsersRef = Firestore.firestore().collection("users")
        appUsersRef.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching app users: \(error?.localizedDescription ?? "")")
                return
            }
            
            self.appUsers = documents.compactMap { snapshot in
                let data = snapshot.data()
                let id = snapshot.documentID
                let name = data["username"] as? String ?? ""
                return AppUser(id: id, name: name)
            }
        }
    }
}

@MainActor
struct UserListView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var searchText = ""
    @State private var showUsers = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        showUsers = true
                        Task {
                            viewModel.fetchAppUsers()
                        }
                    }, label: {
                        Text("Fetch Users")
                    })
                    .disabled(searchText.isEmpty)
                }
                .padding()

                if showUsers {
                    List(viewModel.appUsers.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { appUser in
                        NavigationLink(destination: UserProfileView(appUser: appUser)) {
                            Text(appUser.name)
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("App User List")
        }
    }
}



struct ContentView: View {
    var body: some View {
        UserListView()
    }
}

