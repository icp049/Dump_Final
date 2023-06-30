import SwiftUI
import FirebaseFirestoreSwift

struct MainPageShoutView: View {
    let appUser: AppUser
    
    @FirestoreQuery(collectionPath: "shout")
    var shouts: [Shout]
    
    @FirestoreQuery(collectionPath: "rant")
    var rants: [Rant]
    
    var combinedList: [PostWrapper] {
        let shoutPosts = shouts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false) }
        let rantPosts = rants.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant:true) }
        return (shoutPosts + rantPosts).sorted { $0.postDate > $1.postDate }
    }
    
    @StateObject private var viewModel: MainPageShoutViewViewModel
    
    init(appUser: AppUser) {
        self.appUser = appUser
        self._viewModel = StateObject(wrappedValue: MainPageShoutViewViewModel(appUser: appUser))
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
                        Text(viewModel.formatDate(item.postDate))
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
            viewModel.fetchShoutsAndRantsFromFollowing()
        }
    }
}

struct MainPageShoutView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAppUser = AppUser(id: "1", name: "John Doe") // Example appUser object
        MainPageShoutView(appUser: sampleAppUser)
    }
}

