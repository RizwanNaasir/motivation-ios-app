import SwiftUI

struct ContentView: View {
    @AppStorage("AuthToken") var authToken: String = "" // Make sure to include this if you need AuthToken
    @State private var isLoggedOut: Bool = false

    var body: some View {
        if authToken.isEmpty {
            LoginView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("")
        } else {
            NavigationView {
                TabView {
                    BestQuotesView()
                            .tabItem {
                                Label("Best Quotes", systemImage: "quote.bubble")
                            }
                    MyFavoriteQuotesView()
                            .tabItem {
                                Label("Favorite Quote", systemImage: "heart")
                            }
                    MyFavoriteStoriesView()
                            .tabItem {
                                Label("Favorite Stories", systemImage: "book")
                            }
                    ProfileView()
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                }
            }
                    .background(
                            NavigationStack {
                                Text("") // Add an empty view as a workaround
                                        .navigationDestination(isPresented: $isLoggedOut) {
                                            LoginView()
                                                    .navigationBarBackButtonHidden(true) // Hide the back button in ContentView
                                        }
                            }
                    )
                    .navigationBarTitle("Motivation", displayMode: .inline)
                    .navigationBarItems(
                            trailing: Button(action: logout) {
                                Image(systemName: "arrow.right.square")
                            })

        }
    }

    private func logout() {
        // Perform any logout actions here (e.g., clearing AuthToken)
        // For example, you can clear the AuthToken like this:
        authToken = ""
        isLoggedOut = true
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
