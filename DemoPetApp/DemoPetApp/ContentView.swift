//
//  ContentView.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DemoPetAppViewModel(networkService: AnimalsNetworkService())
    @State var animals: [Animal]
    
    var body: some View {
        NavigationStack {
            List(animals) { animal in
                NavigationLink {
                    AnimalView(animal: animal)
                } label: {
                    Text("Hello, \(animal.name)")
                }
            }
            .navigationTitle("Happy Animals")
        }
    }
    
    init(animals: [Animal]) {
        self.animals = animals
    }
}

#Preview {
    ContentView(animals: DemoPetAppViewModel(networkService: AnimalsNetworkService()).animals)
}

struct AnimalView: View {
    @State var animal: Animal
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hi! My name is: \(animal.name)")
                Text("And I am a: \(animal.gender) \(animal.breed)")
                Text("I'm this size: \(animal.size)")
                Text("Currently I am: \(animal.status)")
                Text("I am this far away from you: \(animal.distance)")
            }
            .navigationTitle(animal.name)
        }
    }
}
