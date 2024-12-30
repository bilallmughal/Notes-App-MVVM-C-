//
//  Notes_MVVM_CApp.swift
//  Notes MVVM-C
//
//  Created by Muhammad Bilal on 30/12/2024.
//

import SwiftUI

@main
struct Notes_MVVM_CApp: App {
    @StateObject private var coordinator = MainCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
                .environmentObject(coordinator)
        }
    }
}
