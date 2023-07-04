import SwiftUI

struct BestQuotesView: View {
    @State private var quotes: [Quote] = []

    var body: some View {
        VStack {
            GreetingsCard()

            // List of Quotes
            if quotes.isEmpty {
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
        request(QUOTES_LIST_ROUTE, method: "GET") { (response: Response<[Quote]>?, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let response = response else {
                print("No response data")
                return
            }

            if let quoteResponse = response.data {
                debugPrint(quoteResponse)
            } else {
                print("No data in the response")
            }
        }
    }
}

struct GreetingsCard: View {
    var body: some View {
        Rectangle()
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                .frame(height: 100)
                .overlay(
                        Text("Greetings! Here are some quotes for you")
                                .font(.title)
                                .colorInvert()
                                .foregroundColor(.white)
                )
    }
}

struct QuoteCard: View {
    let quote: Quote
    @State private var isLiked: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.black)
                    .frame(height: 120)
                    .overlay(
                            Text(quote.content)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                    )

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

struct QuoteResponse: Codable {
    let message: String
    let data: [Quote]
}

