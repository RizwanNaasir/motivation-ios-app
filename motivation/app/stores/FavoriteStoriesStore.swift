import Foundation

class FavoriteStoriesStore: ObservableObject {
    @Published var favoriteStories: [Story] = []

    func addToFavorites(_ story: Story) {
        let mutatedStory = Story(
                id: story.id,
                title: story.title,
                content: story.content,
                createdAt: story.createdAt,
                updatedAt: story.updatedAt,
                isLiked: true
        )
        DispatchQueue.main.async {
            if !self.isStoryAlreadyAddedFavorite(mutatedStory) {
                self.favoriteStories.append(mutatedStory)
            }
        }
    }


    func removeFromFavorites(_ story: Story) {
        DispatchQueue.main.async {
            if let index = self.favoriteStories.firstIndex(where: { $0.id == story.id }) {
                self.favoriteStories.remove(at: index)
            }
        }
    }

    func isStoryAlreadyAddedFavorite(_ story: Story) -> Bool {
        favoriteStories.contains {
            $0.id == story.id
        }
    }

    func getFavoriteStories() -> [Story] {
        favoriteStories
    }
}