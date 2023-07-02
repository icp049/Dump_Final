import SwiftUI
import FirebaseFirestoreSwift




struct MainPageShoutView: View {
    let appUser: AppUser
    
    @FirestoreQuery var shouts: [Shout]
    @FirestoreQuery var rants: [Rant]
    @FirestoreQuery var mehs: [Meh]
    
    var combinedList: [PostWrapper] {
        let shoutPosts = shouts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false, isMeh: false) }
        let rantPosts = rants.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant: true, isMeh: false) }
        let mehPosts = mehs.map { PostWrapper(id: $0.id, content: $0.meh, postDate: $0.postDate, isRant: false, isMeh: true) }
        return (shoutPosts + rantPosts + mehPosts).sorted { $0.postDate > $1.postDate }
    }
    
    @StateObject private var viewModel: MainPageShoutViewViewModel
    
    init(appUser: AppUser) {
        self.appUser = appUser
        self._shouts = FirestoreQuery(collectionPath: "users/\(appUser.id)/shout")
        self._rants = FirestoreQuery(collectionPath: "users/\(appUser.id)/rant")
        self._mehs = FirestoreQuery(collectionPath: "users/\(appUser.id)/meh")
        self._viewModel = StateObject(wrappedValue: MainPageShoutViewViewModel(userId: appUser.id))
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
                .swipeActions {
                    Button("Delete") {
                        viewModel.delete(id: item.id)
                    }
                    .tint(.red)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("\(viewModel.username)'s Shouts")
            .toolbar {
                Button(action: {
                    viewModel.showingNewItemView = true
                }) {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $viewModel.showingNewItemView) {
                    NewShoutView(newItemPresented: $viewModel.showingNewItemView)
                }
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
    
   
}


struct MainPageShoutView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = AppUser(id: "1", name: "John Doe") // Example appUser object
        UserShoutView(appUser: sampleAppUser)
    }
}
