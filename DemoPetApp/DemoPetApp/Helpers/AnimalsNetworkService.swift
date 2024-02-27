//
//  AnimalsNetworkService.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchAnimals() throws -> AnyPublisher<PetfinderAnimals, Error>
}

class AnimalsNetworkService: NetworkServiceProtocol, ObservableObject {
    private let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4RnZCOTJDT0wzbG9Ka1JIQm96R1BMT1ZLWlRHNENnWGFsNkRvdTZFanNINWxqMlNYQiIsImp0aSI6ImYyOGJkMjcxMGQ5YzRlOGY4NWYwM2YzNDgyODhiNjg0MWNlZGFkODJjMDI1MzAwNTQ5MGEzZjBiNjQ5MWFkOTJlMDFlNzE4NGM1MWJiYTY1IiwiaWF0IjoxNzA5MDY0OTQ4LCJuYmYiOjE3MDkwNjQ5NDgsImV4cCI6MTcwOTA2ODU0OCwic3ViIjoiIiwic2NvcGVzIjpbXX0.UXLJ8SfLkyIG4ehMDduT7nWPXyLsQF2C8ViBvo3vziBNxUsZnJLZXnM6LcLgPq9279Pfi5BmreLjpihn7Of_aX2xfZXQBRI9fWHp2zWDB8VaZ3xlHNjyKaw3cTJvBoDcIm1zEjxNR1R_x6XDNAE7fXnpYVTXWCsWjPEm9D3644Pj_SBvQskPP2q1GnRhrieWnurcmoyGPdWEyCQZP9Zm2Ge5qzH9igl-YJb9bykI9xsi_uCggPf4m8GrJW-npUO2MZUa5Ssn5eS_I3ZTG1W7mkTr_j0W9Y0H71Zh57MLJIr-bqWgtsP-walo6L1BvSe4X0YUX-WJ3CaA0kjAnWZE0w"
    private var cancellables = Set<AnyCancellable>()
    private let urlSession: URLSession
    
    @Published var animals: PetfinderAnimals?
    
    private var urlRequest: URLRequest? {
        guard let url = URL(string: "https://api.petfinder.com/v2/animals") else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    // MARK: - NetworkServiceProtocol

    func fetchAnimals() throws -> AnyPublisher<PetfinderAnimals, Error> {
        guard let urlRequest else { throw URLError(.badURL) }
        
        return urlSession.dataTaskPublisher(for: urlRequest)
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
            .eraseToAnyPublisher()
    }
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
}

// MARK: - Private

private extension AnimalsNetworkService {
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200, response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
