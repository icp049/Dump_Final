import SwiftUI

struct UserProfileView: View {
    let appUser: AppUser

    var body: some View {
        Text("User Profile: \(appUser.name)")
        // Add your user profile view logic here
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = AppUser(id: "1", name: "John Doe") // Example appUser object
        UserProfileView(appUser: sampleAppUser)
    }
}

