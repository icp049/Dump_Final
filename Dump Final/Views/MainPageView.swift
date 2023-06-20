import SwiftUI

struct MainPageView: View {
    @State private var selectedTab: Tab = .shouts
    
    enum Tab {
        case shouts
        case photos
    }
    
    var body: some View {
        VStack {
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
            
            if selectedTab == .shouts {
                ShoutsView()
            } else {
                PhotosView()
            }
            
            Spacer()
        }
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

