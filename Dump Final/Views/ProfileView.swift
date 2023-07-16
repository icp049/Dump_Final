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
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.blue)
                                .frame(width: 125, height: 125)
                        }
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.white)
                                .frame(width: 30, height: 30)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .padding(4)
                                .offset(x: 45, y: 45)
                        }
                        .sheet(isPresented: $showImagePicker) {
                            ImagePicker1(sourceType: .photoLibrary) { image in
                                selectedImage = image
                            }
                        }
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
                .sheet(isPresented: $viewmodel.showingNewItemView) {
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


   
