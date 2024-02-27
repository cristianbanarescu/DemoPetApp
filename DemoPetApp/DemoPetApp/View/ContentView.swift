//
//  ContentView.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel: DemoPetAppViewModel
    
    var body: some View {
        NavigationStack {
            let animals = viewModel.animals
            let error = viewModel.error
            let fetchingState = viewModel.fetchingState
            
            VStack {
                if fetchingState == .fetching {
                    ProgressView("Fetching animals")
                }

                if error != nil {
                    ContentUnavailableView("No animals found!", systemImage: "cloud.rain")
                } else {
                    List(animals) { animal in
                        NavigationLink {
                            AnimalView(animal: animal)
                        } label: {
                            Text("Hello, \(animal.name)")
                        }
                    }
                }
            }
            .navigationTitle("Happy Animals")
        }
    }
    
    init(viewModel: DemoPetAppViewModel = DemoPetAppViewModel(networkService: AnimalsNetworkService(urlSession: .shared))) {
        self.viewModel = viewModel
    }
}

#Preview {
    ContentView()
}
