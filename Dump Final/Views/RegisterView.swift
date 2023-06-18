//
//  RegisterView.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import SwiftUI

struct RegisterView: View {
    //attributes
    
    @StateObject var viewModel = RegisterViewViewModel()
    
    
    
    
    
    var body: some View {
        
        Text("Create Account")
            .foregroundColor(Color.green)
            .bold()
            .font(.system(size: 40))
            .padding(.top,60)
        
               //Registration form
        Form{
            
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(DefaultTextFieldStyle())
                .autocorrectionDisabled()
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(DefaultTextFieldStyle())
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(DefaultTextFieldStyle())
                .autocapitalization(.none)
                .autocorrectionDisabled()
        
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(DefaultTextFieldStyle())
                .autocapitalization(.none)
            }
            
            
            Button{
                viewModel.register()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.yellow)
                    
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .bold()
                }
                
            }
           
        }
        
        
        
        
        
    }


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
