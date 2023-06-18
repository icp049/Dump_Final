//
//  Dump_FinalApp.swift
//  Dump Final
//
//  Created by Ian Pedeglorio on 2023-06-17.
//
import FirebaseCore
import SwiftUI

@main
struct Dump_FinalApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
