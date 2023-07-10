import SwiftUI

struct MyFavoriteQuotesView: View {
    @State private var isLoading: Bool = false
    @State private var isRefreshing: Bool = false
    @EnvironmentObject var favoriteQuotesStore: FavoriteQuotesStore

    var body: some View {
        NavigationView {
            VStack {
                // List of Quotes
                if (favoriteQuotesStore.getFavoriteQuotes().isEmpty && !isLoading) {
                    Image("Empty") // Replace with your empty state image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .padding(.bottom, 32.0)
                    Text("No Quotes Found")
                            .padding(.bottom, 16.0)
                    Button(action: {
                        fetchFavQuotes()
                    }) {
                        Text("Refresh From Server")
                    }
                }
                if (isLoading && favoriteQuotesStore.getFavoriteQuotes().isEmpty) {
                    ProgressView().padding(.top) // Show a loading indicator while fetching quotes
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteQuotesStore.getFavoriteQuotes(), id: \.self) { quote in
                                QuoteCard(quote: quote)
                            }
                        }
                                .padding()
                                .refreshable {
                                    fetchFavQuotes()
                                }
                    }
                            .clipped()
                }
            }
                    .onAppear {
                        if favoriteQuotesStore.getFavoriteQuotes().isEmpty {
                            fetchFavQuotes()
                        }
                    }
                    .navigationBarTitle("Favourite Quotes")
        }
    }

    private func fetchFavQuotes() {
        isRefreshing = true
        isLoading = true
        requestData(FAVORITE_QUOTES_LIST_ROUTE, method: "GET") { (response: Response<[Quote]>?, error) in
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
                    favoriteQuotesStore.addToFavorites(item)
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
