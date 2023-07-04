import SwiftUI

struct ContentView: View {
    @AppStorage("AuthToken") var authToken: String = "" // Make sure to include this if you need AuthToken
    @State private var isLoggedOut: Bool = false

    var body: some View {
        NavigationView {
            TabView {
                BestQuotesView()
                        .tabItem {
                            Label("Best Quotes", systemImage: "quote.bubble")
                        }
                ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                MyFavoriteQuotesView()
                        .tabItem {
                            Label("Favorite Quote", systemImage: "heart")
                        }
                MyFavoriteStoriesView()
                        .tabItem {
                            Label("Favorite Stories", systemImage: "book")
                        }
            }
                    .navigationBarItems(trailing: Button("Logout", action: logout))
        }
                .background(
                        NavigationLink(
                                destination: LoginView()
                                        .navigationBarBackButtonHidden(true), // Hide the back button in ContentView
                                isActive: $isLoggedOut,
                                label: { EmptyView() }
                        )
                )
    }

    private func logout() {
        // Perform any logout actions here (e.g., clearing AuthToken)
        // For example, you can clear the AuthToken like this:
        authToken = ""
        isLoggedOut = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
