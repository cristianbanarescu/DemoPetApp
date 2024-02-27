//
//  DemoPetAppViewModel.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation
import SwiftUI
import Combine

enum FetchingState {
    case notFetching
    case fetching
    case finished
}

class DemoPetAppViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var petfinderAnimals: PetfinderAnimals?
    @Published var error: Error?
    @Published var fetchingState: FetchingState = .notFetching
    
    var animals: [Animal] {
        petfinderAnimals?.animals ?? []
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        
        getAnimals()
    }
}

// MARK: - Private

private extension DemoPetAppViewModel {
    func getAnimals() {
        do {
            fetchingState = .fetching
            _ = try networkService.fetchAnimals().sink(receiveCompletion: receivedCompletion, receiveValue: { [weak self] petfinderAnimals in
                self?.petfinderAnimals = petfinderAnimals
                self?.fetchingState = .finished
            })
        } catch {
            if let error = error as? URLError {
                switch error.code {
                case .badURL:
                    print("bad url")
                default:
                    print("other error: \(error.code)")
                }
                self.error = error
                fetchingState = .finished
            }
        }
    }
    
    func receivedCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Finished OK. Completion: \(completion)")
            self.error = nil
        case .failure(let error):
            print(error.localizedDescription)
            self.error = error
        }
        fetchingState = .finished
    }
}
