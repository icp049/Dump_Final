//
//  EditProfileView.swift
//  Dump Final
//
//  Created by Ian Pedeglorio on 2023-07-16.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject var viewModel = EditProfileController()
    @Binding var newItemPresented: Bool
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    
    var body: some View {
        VStack{
            Text("Edit Profile")
                .font(.system(size:32))
                .bold()
                .padding(.top, 100)
            
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
            
            
            // add textfields here for username and name change 
            
           
            
            
            RUButton(title: "Save Changes", background: .green)
            {
                
                newItemPresented = false
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(newItemPresented: Binding(get: {
            return true
        }, set: { _ in
        }))
    }
}


    



    
    
    
    

