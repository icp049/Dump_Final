import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct MyAppUser {
    let id: String
    let name: String
    var shouts: [Shout] = []
    var rants: [Rant] = []
    var mehs: [Meh] = []
}

struct MainPageShoutView: View {
    let appUser: MyAppUser
    
    @FirestoreQuery var shouts: [Shout]
    @FirestoreQuery var rants: [Rant]
    @FirestoreQuery var mehs: [Meh]
    
    var combinedList: [PostWrapper] {
        var postWrappers: [PostWrapper] = []
        
        for user in viewModel.followingUsers {
            postWrappers += user.shouts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false, isMeh: false) }
            postWrappers += user.rants.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant: true, isMeh: false) }
            postWrappers += user.mehs.map { PostWrapper(id: $0.id, content: $0.meh, postDate: $0.postDate, isRant: false, isMeh: true) }
        }
        
        return postWrappers.sorted { $0.postDate > $1.postDate }
    }
    
    @StateObject private var viewModel: MainPageShoutViewViewModel
    
    init(appUser: MyAppUser) {
        self.appUser = appUser
        self._shouts = FirestoreQuery(collectionPath: "users/\(appUser.id)/shout")
        self._rants = FirestoreQuery(collectionPath: "users/\(appUser.id)/rant")
        self._mehs = FirestoreQuery(collectionPath: "users/\(appUser.id)/meh")
        self._viewModel = StateObject(wrappedValue: MainPageShoutViewViewModel(appUser: appUser))
    }
    
    var body: some View {
        let content = List(combinedList) { item in
            VStack {
                HStack {
                    Text(item.content)
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    Text(viewModel.formatDate(item.postDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    
                    if item.isRant {
                        Text("😡")
                            .font(.title)
                            .foregroundColor(.yellow)
                    } else if item.isMeh {
                        Text("😐")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(item.isRant ? Color.red.opacity(0.2) : item.isMeh ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
            .cornerRadius(8)
            
        }
        
        return NavigationView {
            content
                .listStyle(PlainListStyle())
               
        }
        .onAppear {
            viewModel.fetchFollowingUsers(for: appUser.id)
        }
    }

}

struct MainPageShoutView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = MyAppUser(id: "1", name: "John Doe") // Example appUser object
        MainPageShoutView(appUser: sampleAppUser)
    }
}

