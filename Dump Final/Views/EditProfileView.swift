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
    
    var body: some View {
        VStack{
            Text("Edit Profile")
                .font(.system(size:32))
                .bold()
                .padding(.top, 100)
            
            
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
        }, set: { _ in
        }))
    }
}


    



    
    
    
    

