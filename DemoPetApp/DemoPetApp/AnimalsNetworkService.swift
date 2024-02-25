//
//  AnimalsNetworkService.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchAnimals() -> [Animal]
}

struct AnimalsNetworkService: NetworkServiceProtocol {
    func fetchAnimals() -> [Animal] {
        [Animal.mock()] // TODO: fix this with an actual request using Combine
    }
}
