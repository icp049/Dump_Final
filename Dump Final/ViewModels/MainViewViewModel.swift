//
//  MainViewViewModel.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import Foundation
import FirebaseAuth

class MainViewViewModel: ObservableObject{
    @Published var currentUserId: String = ""
   private var handler: AuthStateDidChangeListenerHandle?
    
    init () {
        self.handler = Auth.auth().addStateDidChangeListener {[weak self] _, user in
            
            DispatchQueue.main.async{
                
                
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedin: Bool{
        Auth.auth().currentUser != nil
    }
}
