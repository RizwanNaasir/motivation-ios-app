import SwiftUI

struct BestStoriesView: View {
    @State private var quotes: [Quote] = []
    @State private var isLoading: Bool = false
    @State private var isRefreshing: Bool = false
    @EnvironmentObject var favoriteQuotesStore: FavoriteQuotesStore

    var body: some View {
        VStack {
            // List of Quotes
            if (quotes.isEmpty && !isLoading) {
                Image("Empty") // Replace with your empty state image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .padding(.bottom, 32.0)
                Text("No Quotes Found")
                        .padding(.bottom, 16.0)
                Button(action: {
                    refreshFromServer()
                }) {
                    Text("Refresh From Server")
                }
            }
            if (isLoading && quotes.isEmpty) {
                ProgressView().padding(.top) // Show a loading indicator while fetching quotes
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(quotes, id: \.self) { quote in
                            QuoteCard(quote: quote).environmentObject(favoriteQuotesStore)
                        }
                    }
                            .padding()
                            .refreshable {
                                fetchQuotes()
                            }
                }
                        .clipped()
            }
        }
                .onAppear {
                    fetchQuotes()
                }
    }

    private func fetchQuotes() {
        isRefreshing = true
        isLoading = true
        requestData(QUOTES_LIST_ROUTE, method: "GET") { (response: Response<[Quote]>?, error) in
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
                quotes = quoteResponse
            } else {
                print("No data in the response")
            }
        }
    }

    private func refreshFromServer() {
        isLoading = true
        request(REFRESH_QUOTES_ROUTE, method: "POST") { error in
            isLoading = false
            if let error = error {
                print("Error: \(error)")
                return
            }
            print("Successfully refreshed quotes")
            fetchQuotes()
        }
    }
}
