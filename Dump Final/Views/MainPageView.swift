import SwiftUI

struct MainPageView: View {
    var body: some View {
        TabView {
            ShoutsView()
                .tabItem {
                    Label("Shouts", systemImage: "message")
                }
            
            PhotosView()
                .tabItem {
                    Label("Photos", systemImage: "photo")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
        .indexViewStyle(PageIndexViewStyle())
       
    }
}

struct ShoutsView: View {
    var body: some View {
        Text("Hello, Shouts!")
    }
}

struct PhotosView: View {
    var body: some View {
        Text("Hello, Photos!")
    }
}

struct MainPageView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}

