//
//  Shouts.swift
//  Dump
//
//  Created by Ian Pedeglorio on 2023-06-08.
//

import Foundation



struct Shouts: Codable, Identifiable {
    let id: String
    let shout: String
    let postDate: TimeInterval
    let postTime: TimeInterval

    
    
}
