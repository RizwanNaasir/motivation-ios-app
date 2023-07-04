//
//  Toast.swift
//  motivation
//
//  Created by InterLink on 6/28/23.
//

import SwiftUI

struct ToastView<Content: View>: View {
    @Binding var isShowing: Bool
    let content: Content
    
    var body: some View {
        VStack {
            Spacer()
            if isShowing {
                content
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
            }
        }
    }
}