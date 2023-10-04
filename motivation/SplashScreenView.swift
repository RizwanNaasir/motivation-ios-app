//
//  SplashScreenView.swift
//  SplashScreen
//
//  Created by Federico on 20/01/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    // Customise your SplashScreen here
    var body: some View {
        if isActive {
            NavigationView {
                ContentView()
                        .environmentObject(FavoriteQuotesStore())
                        .environmentObject(FavoriteStoriesStore())
            }
        } else {
            VStack {
                VStack {
                    Text("Welcome To")
                        .font(.system(size: 24, weight: .bold))
                    // Adjust the size and weight as needed
                    Text("Motivation App")
                        .font(.system(size: 24, weight: .bold))
                    // Adjust the size and weight as needed
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
