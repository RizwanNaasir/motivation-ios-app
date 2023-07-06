//
//  motivationApp.swift
//  motivation
//
//  Created by InterLink on 6/26/23.
//

import SwiftUI

@main
struct motivationApp: App {
    let favoriteQuotesStore = FavoriteQuotesStore() // Create an instance of FavoriteQuotesStore

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(favoriteQuotesStore)
            }
        }
    }
}
