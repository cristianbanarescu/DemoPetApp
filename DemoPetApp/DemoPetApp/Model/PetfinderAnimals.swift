//
//  PetfinderAnimals.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation

struct PetfinderAnimals: Decodable, Identifiable {
    var id: String = UUID().uuidString
    let animals: [Animal]
    
    enum CodingKeys: CodingKey {
        case animals
    }
}

struct Animal: Identifiable, Decodable {
    let id: Int
    let name: String
    let breeds: Breed
    let size: String
    let gender: String
    let status: String
    let distance: Int?

    static func mock() -> Self {
        Animal(id: 0, name: "Test", breeds: Breed(primary: "", secondary: "", mixed: true, unknown: true), size: "Small", gender: "Male", status: "Adopted", distance: 1)
    }
}

struct Breed: Codable {
    let primary: String
    let secondary: String?
    let mixed: Bool
    let unknown: Bool
}
