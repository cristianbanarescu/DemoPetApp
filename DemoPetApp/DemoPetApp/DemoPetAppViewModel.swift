//
//  DemoPetAppViewModel.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation

class DemoPetAppViewModel: ObservableObject {
    let networkService: NetworkServiceProtocol
    @Published var animals: [Animal] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        animals = networkService.fetchAnimals()
    }
}
