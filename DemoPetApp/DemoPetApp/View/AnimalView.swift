//
//  AnimalView.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 27.02.2024.
//

import SwiftUI

struct AnimalView: View {
    @State private var animal: Animal
    
    var body: some View {
        NavigationStack {
            let animalName = animal.name
            VStack {
                Text("Hi! My name is: \(animalName)")
                Text("And I am a: \(animal.gender) \(animal.breeds.primary)")
                Text("I'm this size: \(animal.size)")
                Text("Currently I am: \(animal.status)")
                Text("I am this far away from you: \(animal.distance ?? 0)")
            }
            .navigationTitle(animalName)
        }
    }
    
    init(animal: Animal) {
        self.animal = animal
    }
}

#Preview {
    AnimalView(animal: Animal.mock())
}
