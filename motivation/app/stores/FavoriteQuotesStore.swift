import Foundation

class FavoriteQuotesStore: ObservableObject {
    @Published var favoriteQuotes: [Quote] = []

    func addToFavorites(_ quote: Quote) {
        DispatchQueue.main.async {
            if !self.isQuoteAlreadyAddedFavorite(quote) {
                self.favoriteQuotes.append(quote)
            }
        }
    }

    func removeFromFavorites(_ quote: Quote) {
        DispatchQueue.main.async {
            if let index = self.favoriteQuotes.firstIndex(where: { $0.id == quote.id }) {
                self.favoriteQuotes.remove(at: index)
            }
        }
    }

    func isQuoteAlreadyAddedFavorite(_ quote: Quote) -> Bool {
        favoriteQuotes.contains {
            $0.id == quote.id
        }
    }

    func getFavoriteQuotes() -> [Quote] {
        favoriteQuotes
    }
}