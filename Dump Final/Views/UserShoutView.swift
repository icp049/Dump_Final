import SwiftUI
import FirebaseFirestoreSwift




struct UserShoutView: View {
    let appUser: AppUser
    
    @FirestoreQuery var shouts: [Shout]
    @FirestoreQuery var rants: [Rant]
    
    var combinedList: [PostWrapper] {
        let shoutPosts = shouts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false) }
        let rantPosts = rants.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant:true) }
        return (shoutPosts + rantPosts).sorted { $0.postDate > $1.postDate }
    }
    
    @StateObject private var viewModel: ShoutViewViewModel
    
    init(appUser: AppUser) {
        self.appUser = appUser
        self._shouts = FirestoreQuery(collectionPath: "users/\(appUser.id)/shout")
        self._rants = FirestoreQuery(collectionPath: "users/\(appUser.id)/rant")
        self._viewModel = StateObject(wrappedValue: ShoutViewViewModel(userId: appUser.id))
    }
    
    var body: some View {
        NavigationView {
            List(combinedList) { item in
                VStack {
                    HStack {
                        Text(item.content)
                            .font(.headline)
                        Spacer()
                    }
                    
                    HStack {
                        Text(formatDate(item.postDate))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        
                        if item.isRant {
                            Text("😡")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(item.isRant ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                .cornerRadius(8)
                
            }
            .listStyle(PlainListStyle())
            
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    }


struct UserShoutView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = AppUser(id: "1", name: "John Doe") // Example appUser object
        UserShoutView(appUser: sampleAppUser)
    }
}

