//
//  DemoPetAppApp.swift
//  DemoPetApp
//
//  Created by Cristian Banarescu on 25.02.2024.
//

import SwiftUI

@main
struct DemoPetAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(animals: DemoPetAppViewModel(networkService: AnimalsNetworkService()).animals)
        }
    }
}
