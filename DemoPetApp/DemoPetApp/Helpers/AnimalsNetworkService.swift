//
//  AnimalsNetworkService.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    var urlRequest: URLRequest? { get }
    var animalsPublisher: AnyPublisher<PetfinderAnimals?, Never> { get }
    var urlSession: URLSession { get }
    func fetchAnimals() throws
}

class AnimalsNetworkService: NetworkServiceProtocol, ObservableObject {
    private let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4RnZCOTJDT0wzbG9Ka1JIQm96R1BMT1ZLWlRHNENnWGFsNkRvdTZFanNINWxqMlNYQiIsImp0aSI6ImNkMzFmMzIzZTY1ZWZlN2UzMWU2YjBiNGU4MGM5NmExNjNjM2E3MzI0NmQwOTJiZDdmOTk4ZTE1YTQzMTdjMDM0MDlkZDRiMmE1MzM0NmI0IiwiaWF0IjoxNzA5MDYwNDEwLCJuYmYiOjE3MDkwNjA0MTAsImV4cCI6MTcwOTA2NDAxMCwic3ViIjoiIiwic2NvcGVzIjpbXX0.vWISCVBGObQh3eUtaKrxNtU6rXjuKOy9_x5K0IccrwgKolPbI--d5V83tbyZjDpCiHBj8toVZBNVJ9MD5vwLkqHQb9He7rVb41xEQYhsn0pxFYZndUUS7C58-L3-BENXmnrYV1xfoSQCA9XGzsMw-EywAQ0GULTOX5C93Z9CN-NZAJ9kucAxGr_lsn7VF-UZmjVesMaFR3BYVvy4XyoZbVPaVI--fybC-blXk4Ajc0gNRIRJYJ_6eyEW5DPH04ttZrSNg964jVCXqQiynU20do_s0InexE1Yl0xsSIVZZ50NJv4q40oGLkMKyShpxZ3WIRPlVI2BuJrGKK_hwvdq_g"
    private var cancellables = Set<AnyCancellable>()
    @Published private var animals: PetfinderAnimals?
    
    // MARK: - NetworkServiceProtocol
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: "https://api.petfinder.com/v2/animals") else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    var animalsPublisher: AnyPublisher<PetfinderAnimals?, Never> {
        $animals
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    let urlSession: URLSession
    
    func fetchAnimals() throws {
        guard let urlRequest else { throw URLError(.badURL) }
        
        urlSession.dataTaskPublisher(for: urlRequest) // TODO: inject data task publisher instead of using URLSession.shared
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: PetfinderAnimals.self, decoder: JSONDecoder())
            .mapError({ error in
                if let decodingError = error as? DecodingError {
                    print("decodingError: \(decodingError)")
                }
                return error
            })
            .sink(receiveCompletion: receivedCompletion(completion:), receiveValue: { [weak self] fetchedAnimals in
                self?.animals = fetchedAnimals
            })
            .store(in: &cancellables)
    }
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
        tryToFetchAnimals()
    }
    
    // MARK: - Private
    
    private func tryToFetchAnimals() {
        do {
            try fetchAnimals()
        } catch {
            if let error = error as? URLError {
                switch error.code {
                case .badURL:
                    print("bad url")
                default:
                    print("other error: \(error.code)")
                }
            }
        }
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200, response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    private func receivedCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            print("Finished OK. Completion: \(completion)")
        case .failure(let error):
            // TODO: send back error to ContentView in order to show some alert controller with message and error message
            print(error.localizedDescription)
        }
    }
}
