//
//  ProfileView.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import SwiftUI



struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewViewModel()
    var body: some View {
        NavigationView{
            VStack{
                if let user = viewModel.user{
                    // Avatar
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.blue)
                        .frame(width: 125, height: 125)
                       
                    
                    
                    //all the info
                    VStack(alignment: .leading){
                        HStack{
                            Text("Name")
                            Text(user.name)
                            
                        }
                        HStack{
                            Text("Email")
                            Text(user.email)
                        }
                        
                    }
                    
                    
                    
                    //sign out button
                    Button{
                        //action for signout
                        
                        viewModel.logOut()
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.yellow)
                            
                            Text("Sign Out")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                } else {
                    Text("Loading Profile")
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
