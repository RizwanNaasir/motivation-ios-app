import Foundation

class FavoriteQuotesStore: ObservableObject {
    @Published var favoriteQuotes: [Quote] = []

    func addToFavorites(_ quote: Quote) {
        let mutatedQuote = Quote(
                id: quote.id,
                content: quote.content,
                author: quote.author,
                tags: quote.tags,
                authorSlug: quote.authorSlug,
                length: quote.length,
                createdAt: quote.createdAt,
                updatedAt: quote.updatedAt,
                isLiked: true
        )

        DispatchQueue.main.async {
            if !self.isQuoteAlreadyAddedFavorite(mutatedQuote) {
                self.favoriteQuotes.append(mutatedQuote)
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