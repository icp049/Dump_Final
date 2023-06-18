import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.isSignedin, !viewModel.currentUserId.isEmpty {
                TabView {
                    MainPageView()
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
                }
            } else {
                LoginView()
            }
        }
    }
}

