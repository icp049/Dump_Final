//
//  LoginView.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import SwiftUI

struct LoginView: View {
    
    @State var viewModel = LoginViewViewModel()
   
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                //header
                Text("Dump")
                    .foregroundColor(Color.blue)
                    .bold()
                    .font(.system(size: 60))
                    .padding(.top,60)
                
                
               
             
                
                
                
                
                
                //login form
                Form{
                    
                    //error message
                    if  !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button{
                        //action for login
                        
                        viewModel.login()
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.yellow)
                            
                            Text("Log in")
                                .foregroundColor(Color.white)
                                .bold()
                        }
                    }
                    
                }
                
                
                
                
                
                //Create account
                VStack{
                    Text("New around here?")
                    NavigationLink("Create an Account", destination: RegisterView())
                        //show registration
                    
                }
                .padding(.bottom,50)
                Spacer()
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
