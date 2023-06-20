import SwiftUI

struct UserProfileView: View {
    let user: ProfileUser
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile header
            ProfileHeaderView(user: user)
            
            // Buttons for photos and shouts
            HStack(spacing: 20) {
                Button(action: {
                    // Handle photos button action
                }) {
                    Text("Photos")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Handle shouts button action
                }) {
                    Text("Shouts")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationBarTitle(Text(user.username), displayMode: .inline)
    }
}

struct ProfileHeaderView: View {
    let user: ProfileUser
    
    var body: some View {
        VStack(spacing: 10) {
            // Avatar view
            AvatarView(imageName: user.avatar)
            
            // Username
            Text(user.username)
                .font(.title)
        }
    }
}

struct AvatarView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipShape(Circle())
    }
}

struct ProfileUser: Identifiable {
    let id: Int
    let username: String
    let avatar: String
}

struct UserProfileView_Previews: PreviewProvider {
    static let user = ProfileUser(id: 1, username: "JohnDoe", avatar: "avatar_image")
    
    static var previews: some View {
        UserProfileView(user: user)
    }
}

