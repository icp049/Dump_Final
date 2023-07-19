import SwiftUI
import FirebaseFirestoreSwift

struct Shout: Codable, Identifiable {
    let id: String
    let shout: String
    let postDate: TimeInterval
    let postTime: TimeInterval
   
}

struct Rant: Codable, Identifiable {
    let id: String
    let rant: String
    let postDate: TimeInterval
    let postTime: TimeInterval

}

struct Meh: Codable, Identifiable {
    let id: String
    let meh: String
    let postDate: TimeInterval
    let postTime: TimeInterval

}

struct PostWrapper: Identifiable {
    let id: String
    let content: String
    let postDate: TimeInterval
    let isRant: Bool
    let isMeh: Bool
}

struct ShoutView: View {
    @StateObject var viewModel: ShoutViewViewModel
    @FirestoreQuery var shouts: [Shout]
    @FirestoreQuery var rants: [Rant]
    @FirestoreQuery var mehs: [Meh]
    
    var combinedList: [PostWrapper] {
        let shoutPosts = shouts.map { PostWrapper(id: $0.id, content: $0.shout, postDate: $0.postDate, isRant: false, isMeh: false) }
        let rantPosts = rants.map { PostWrapper(id: $0.id, content: $0.rant, postDate: $0.postDate, isRant: true, isMeh: false) }
        let mehPosts = mehs.map { PostWrapper(id: $0.id, content: $0.meh, postDate: $0.postDate, isRant: false, isMeh: true) }
        return (shoutPosts + rantPosts + mehPosts).sorted { $0.postDate > $1.postDate }
    }
    
    init(userId: String) {
        self._shouts = FirestoreQuery(collectionPath: "users/\(userId)/shout")
        self._rants = FirestoreQuery(collectionPath: "users/\(userId)/rant")
        self._mehs = FirestoreQuery(collectionPath: "users/\(userId)/meh")
        self._viewModel = StateObject(wrappedValue: ShoutViewViewModel(userId: userId))
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



struct ShoutView_Previews: PreviewProvider {
    static var previews: some View {
        ShoutView(userId: "KW4SJkka8ES6n6Ju99zgw1FD3u33")
    }
}

