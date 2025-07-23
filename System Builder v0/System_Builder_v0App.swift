//
//  System_Builder_v0App.swift
//  System Builder v0
//
//  Created by snzhrk on 13.07.2025.
//

import SwiftUI

@main
struct System_Builder_v0App: App {
    @StateObject private var store = HabitStore()
    
    var body: some Scene {
        WindowGroup {
            HabitsListView()
                .environmentObject(store) 
        }
    }
}
