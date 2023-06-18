//
//  LoginViewViewModel.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    
    
    func login(){
        guard validate() else {
            return
        }
        
        //if validated
        
        Auth.auth().signIn(withEmail:email, password:password)
        
        
    }
    
    
    
    private func validate() -> Bool{
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            
            errorMessage = "Please fill in all fields"
            
            return false
            
        }
        
        guard email.contains("@") && email.contains(".")  else {
            errorMessage = "Please Enter valid email"
            return false
        }
        return true
    }
    
}
