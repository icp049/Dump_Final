import SwiftUI

struct UserProfileView: View {
    let appUser: AppUser
    
    @State private var selectedTab: Tab = .shouts
    
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
                    Text("Name:")
                    Text("")
                }
                Button(action: {
                    // Handle the follow action
                }) {
                    Text("Follow")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
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
                
                if selectedTab == .shouts {
                    ShoutsView()
                } else {
                    PhotosView()
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

