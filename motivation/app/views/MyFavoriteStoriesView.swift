//
// Created by InterLink on 7/3/23.
//

import SwiftUI

struct MyFavoriteStoriesView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("MyFavoriteStoriesView")
                        .font(.largeTitle)
                        .padding()
            }
                    .navigationBarTitle("Favourite Stories")
        }
    }
}