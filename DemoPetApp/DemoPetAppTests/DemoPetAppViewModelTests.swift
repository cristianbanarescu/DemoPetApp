//
//  DemoPetAppViewModelTests.swift
//  DemoPetAppTests
//
//  Created by Cristian Banarescu on 27.02.2024.
//

import XCTest
import Combine
@testable import DemoPetApp

final class DemoPetAppViewModelTests: XCTestCase {

    private var viewModel: DemoPetAppViewModel {
        DemoPetAppViewModel(networkService: MockNetworkService())
    }
    
    func testAnimals() {
        XCTAssertEqual(viewModel.animals, [Animal.mock()])
    }
}

class MockNetworkService: NetworkServiceProtocol {
    enum MyAppError: Error {
        case networkError
    }
    
    func fetchAnimals() throws -> AnyPublisher<PetfinderAnimals, Error> {
        let results: [Result<PetfinderAnimals, Error>] = [
            .success(PetfinderAnimals(animals: [Animal.mock()])),
            .failure(MyAppError.networkError)
        ]
        
        let sequencePublisher = Publishers.Sequence<[Result<PetfinderAnimals, Error>], Error>(sequence: results)
        
        let mappedPublisher = sequencePublisher.flatMap { result -> AnyPublisher<PetfinderAnimals, Error> in
            switch result {
            case .success(let value):
                return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        return mappedPublisher.eraseToAnyPublisher()
    }
}
