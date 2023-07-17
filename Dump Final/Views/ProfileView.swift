import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                  
                    ZStack {
                        Circle()
                            .foregroundColor(Color.blue)
                            .frame(width: 125, height: 125)
                        
                       
                    }

                    
                    // All the info
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name")
                            Text(user.name)
                        }
                        HStack {
                            Text("Email")
                            Text(user.email)
                        }
                    }
                    
                    // Sign out button
                    Button {
                        viewModel.logOut()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.yellow)
                            
                            Text("Sign Out")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                    .frame(width: 120, height: 40)
                } else {
                    Text("Loading Profile")
                }
                Button {
                    viewModel.showingNewItemView = true;
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.top, 20)
                            .foregroundColor(Color.orange)
                        
                        Text("Edit Profile")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                }
                .sheet(isPresented: $viewModel.showingNewItemView) {
                    EditProfileView(newItemPresented: $viewModel.showingNewItemView)
                }
            }
            .navigationTitle("My Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


   
