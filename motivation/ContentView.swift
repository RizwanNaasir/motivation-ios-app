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
            NavigationView {
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
                    .navigationBarTitle("Motivation", displayMode: .inline)
                    .navigationBarItems(
                            trailing: Button(action: logout) {
                                Image(systemName: "arrow.right.square")
                            })
                    .navigationBarItems(
                            leading: Button(action: profilePage) {
                                Image(systemName: "person.circle")
                            })
                    .overlay(
                            VStack {
                                Spacer()
                                Button(action: {
                                    isBottomSheetPresented = true
                                }) {
                                    Image(systemName: "plus")
                                            .font(.system(size: 24))
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .clipShape(Circle())
                                            .shadow(radius: 4)
                                }
                                        .padding(.bottom, 60)
                                        .padding(.trailing, 20)
                            }
                            , alignment: .bottomTrailing
                    )
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

    public func profilePage() {
        showProfilePage = true
        print(showProfilePage)
    }
}
