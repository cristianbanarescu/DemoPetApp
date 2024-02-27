//
//  DemoPetAppViewModel.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation
import SwiftUI
import Combine

class DemoPetAppViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var petfinderAnimals: PetfinderAnimals?
    
    var animals: [Animal] {
        petfinderAnimals?.animals ?? []
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        
        networkService.animalsPublisher.sink { [weak self] animals in
            self?.petfinderAnimals = animals
        }      
        .store(in: &cancellables)
    }
}
