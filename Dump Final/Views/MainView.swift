import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @State private var appUser: AppUser = AppUser(id: "1", name: "John Doe")

    
    var body: some View {
        NavigationView {
            if viewModel.isSignedin, !viewModel.currentUserId.isEmpty {
                TabView {
                    MainPageView(appUser: appUser)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    ScrapBookView()
                        .tabItem {
                            Label("ScrapBook", systemImage: "photo")
                        }
                    
                    ShoutView(userId: viewModel.currentUserId) // Provide the user ID here
                        .tabItem {
                            Label("Shouts", systemImage: "house")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                    UserListView()
                        .tabItem {
                            Label("Stalk", systemImage: "person.circle")
                        }
                    
                }
            } else {
                LoginView()
            }
        }
    }
}

