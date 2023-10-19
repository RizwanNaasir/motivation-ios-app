import SwiftUI

struct ContentView: View {
    @AppStorage("AuthToken") var authToken: String = "" // Make sure to include this if you need AuthToken
    @State private var isLoggedOut: Bool = false
    @State private var showProfilePage: Bool = false
    @State private var isBottomSheetPresented: Bool = false

    var body: some View {
        if authToken.isEmpty {
            LoginView()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitle("")
        } else {
            TabView {
                BestQuotesView()
                        .tabItem {
                            Label("Best Quotes", systemImage: "quote.bubble")
                        }
                BestStoriesView()
                        .tabItem {
                            Label("Best Stories", systemImage: "book.fill")
                        }
                MyFavoriteQuotesView()
                        .tabItem {
                            Label("Favorite Quote", systemImage: "heart")
                        }

                MyFavoriteStoriesView()
                        .tabItem {
                            Label("Favorite Stories", systemImage: "book")
                        }
                GoalsView()
                        .tabItem {
                            Label("Notes", systemImage: "note")
                        }
                ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
            
            }
                    .background(
                            NavigationStack {
                                EmptyView() // Add an empty view as a workaround
                                        .navigationDestination(isPresented: $isLoggedOut) {
                                            LoginView()
                                                    .navigationBarBackButtonHidden(true) // Hide the back button in ContentView
                                        }
                            }
                    )
                    .background(
                            NavigationStack {
                                EmptyView() // Add an empty view as a workaround
                                        .navigationDestination(isPresented: $showProfilePage) {
                                            ProfileView()
                                        }
                            }
                    )
                    .navigationBarItems(
                                                trailing: Button(action: logout) {
                                                    Image(systemName: "arrow.right.square")
                                                    Text("Logout")
                                                })
                    .navigationBarTitle("Motivation", displayMode: .inline)
                    .sheet(isPresented: $isBottomSheetPresented) {
                        // The content of the bottom sheet view
                        BottomSheetView()
                    }
        }
    }

    private func logout() {
        // Perform any logout actions here (e.g., clearing AuthToken)
        // For example, you can clear the AuthToken like this:
        authToken = ""
        isLoggedOut = true
    }
}
