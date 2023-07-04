import SwiftUI

struct BestQuotesView: View {
    @State private var quotes: [Quote] = []
    @State private var isLoading: Bool = false
    var body: some View {
        VStack {
            // List of Quotes
            if(quotes.isEmpty && !isLoading){
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
                            QuoteCard(quote: quote)
                        }
                    }
                            .padding()
                }
            }
        }
                .onAppear {
                    fetchQuotes()
                }
    }

    private func fetchQuotes() {
        requestData(QUOTES_LIST_ROUTE, method: "GET") { (response: Response<[Quote]>?, error) in
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

struct QuoteCard: View {
    let quote: Quote
    @State private var isLiked: Bool = false

    var body: some View {
        VStack(spacing: 8) {
            Text(quote.content)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()

            Divider() // Add a divider between the content and author

            HStack {
                Text("Author: ")
                        .italic()

                Text(quote.author)

                Spacer()

                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                            .font(.system(size: 20))
                            .padding(8)
                }
                        .padding(8)
            }
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .cornerRadius(10)
        }
    }
}

private func addToFavorites() {
    // Perform any actions here to add the quote to favorites

}

struct BestQuotesView_Previews: PreviewProvider {
    static var previews: some View {
        BestQuotesView()
    }
}
