import SwiftUI

struct BestQuotesView: View {
    @State private var quotes: [Quote] = []
    @State private var isLoading: Bool = false
    @State private var isRefreshing: Bool = false

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
                            QuoteCard(quote: quote)
                        }
                    }
                            .padding()
                            .refreshable {
                                fetchQuotes()
                            }
                }
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

struct QuoteCard: View {
    let quote: Quote
    @State private var isLiked: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme

    init(quote: Quote) {
        self.quote = quote
        _isLiked = State(initialValue: quote.isLiked ?? false)
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 6) {
                HStack {
                    Text(quote.author)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .font(Font.title2.bold())
                            .foregroundColor(.primary)
                    Spacer()
                }

                HStack {
                    Text(quote.content)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(3)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    Spacer()
                }
                HStack {
                    ForEach(quote.tags ?? [], id: \.self) { tag in
                        Text(tag)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: {
                        isLoading = true
                        addToFavorites(id: quote.id) { success in
                            if success {
                                isLoading = false
                                isLiked.toggle()
                            } else {
                                isLoading = false
                            }
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                                .font(.system(size: 20))
                                .padding(8)
                    }
                            .padding(8).disabled(isLoading)
                }
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .cornerRadius(10)
            }
        }
                .padding(15)
                .background(colorScheme == .dark ? Color(.darkGray) : Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .black.opacity(0.1), radius: 15, x: 0, y: 5)
    }
}

private func addToFavorites(id: Int, completion: @escaping (Bool) -> Void) {
    request(ADD_TO_FAVORITES_ROUTE + String(id), method: "POST") { error in
        if let error = error {
            print("Error: \(error)")
            completion(false)
            return
        }
        completion(true)
    }
}

//struct BestQuotesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BestQuotesView()
//    }
//}
