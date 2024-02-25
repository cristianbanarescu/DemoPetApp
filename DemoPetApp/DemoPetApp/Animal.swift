//
//  Animal.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation

struct Animal: Identifiable {
    var id: String = UUID().uuidString
    let name: String
    let breed: String
    let size: String
    let gender: String
    let status: String
    let distance: Int 
    
    static func mock() -> Self {
        Animal(name: "Test", breed: "Dog", size: "Small", gender: "Male", status: "Adopted", distance: 1)
    }
}
