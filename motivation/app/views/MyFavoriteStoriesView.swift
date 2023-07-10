import SwiftUI

struct MyFavoriteStoriesView: View {
    @State private var isLoading: Bool = false
    @State private var isRefreshing: Bool = false
    @EnvironmentObject var favoriteStoriesStore: FavoriteStoriesStore

    var body: some View {
        NavigationView {
            VStack {
                // List of Quotes
                if (favoriteStoriesStore.getFavoriteStories().isEmpty && !isLoading) {
                    Image("Empty") // Replace with your empty state image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .padding(.bottom, 32.0)
                    Text("No Quotes Found, Add it from Best Quotes")
                            .padding(.bottom, 16.0)
                }
                if (isLoading && favoriteStoriesStore.getFavoriteStories().isEmpty) {
                    ProgressView().padding(.top) // Show a loading indicator while fetching quotes
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteStoriesStore.getFavoriteStories(), id: \.self) { story in
                                StoryCard(story: story).environmentObject(favoriteStoriesStore)
                            }
                        }
                                .padding()
                                .refreshable {
                                    fetchFavStories()
                                }
                    }
                            .clipped()
                }
            }
                    .onAppear {
                        if favoriteStoriesStore.getFavoriteStories().isEmpty {
                            fetchFavStories()
                        }
                    }
                    .navigationBarTitle("Favourite Stories")
        }
    }

    private func fetchFavStories() {
        isRefreshing = true
        isLoading = true
        requestData(FAVORITE_STORIES_LIST_ROUTE, method: "GET") { (response: Response<[Story]>?, error) in
            isRefreshing = false
            isLoading = false
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let response = response else {
                print("No response data")
                return
            }

            if let quoteResponse = response.data {
                for item in quoteResponse {
                    favoriteStoriesStore.addToFavorites(item)
                }
            } else {
                print("No data in the response")
            }
        }
    }
}

//struct BestQuotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BestQuotesView()
//    }
//}
