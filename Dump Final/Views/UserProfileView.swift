import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    let appUser: AppUser
    
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var selectedTab: Tab = .shouts
    @State private var isFollowing: Bool = false
    
    enum Tab {
        case shouts
        case photos
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundColor(Color.blue)
                .frame(width: 125, height: 125)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(appUser.name)
                }
                Button(action: {
                    if let currentUserId = Auth.auth().currentUser?.uid {
                        if isFollowing {
                            viewModel.unfollowUser(userId: appUser.id, currentUserId: currentUserId)
                        } else {
                            viewModel.followUser(userId: appUser.id, currentUserId: currentUserId)
                        }
                        isFollowing.toggle()
                    } else {
                        // Handle the case where the current user is not available
                        print("Current user is not available.")
                    }
                }) {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isFollowing ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                HStack {
                    Button(action: {
                        selectedTab = .shouts
                    }) {
                        Text("Shouts")
                            .font(.headline)
                            .foregroundColor(selectedTab == .shouts ? .blue : .gray)
                    }
                    .padding()
                    
                    Button(action: {
                        selectedTab = .photos
                    }) {
                        Text("Photos")
                            .font(.headline)
                            .foregroundColor(selectedTab == .photos ? .blue : .gray)
                    }
                    .padding()
                }
                
                Group {
                    if selectedTab == .shouts {
                        UserShoutView(appUser: appUser)
                    } else {
                        PhotosView()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = AppUser(id: "1", name: "John Doe") // Example appUser object
        UserProfileView(appUser: sampleAppUser)
    }
}

