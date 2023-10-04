import SwiftUI

struct BestStoriesView: View {
    @State private var stories: [Story] = []
    @State private var isLoading: Bool = false
    @State private var isRefreshing: Bool = false
    @EnvironmentObject var favoriteStoriesStore: FavoriteStoriesStore

    var body: some View {
        NavigationView {
            VStack {
                // List of Stories
                if (stories.isEmpty && !isLoading) {
                    Image("Empty") // Replace with your empty state image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .padding(.bottom, 32.0)
                    Text("No Stories Found")
                            .padding(.bottom, 16.0)
                }
                if (isLoading && stories.isEmpty) {
                    ProgressView().padding(.top) // Show a loading indicator while fetching stories
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(stories, id: \.self) { story in
                                StoryCard(story: story).environmentObject(favoriteStoriesStore)
                            }
                        }
                                .padding()
                                .refreshable {
                                    fetchStories()
                                }
                    }
                            .clipped()
                }
            }
                    .onAppear {
                        fetchStories()
                    }
                    .navigationBarTitle("Best Stories")
        }
    }

    private func fetchStories() {
        isRefreshing = true
        isLoading = true
        requestData(STORIES_LIST_ROUTE, method: "GET") { (response: Response<[Story]>?, error) in
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
                stories = quoteResponse
            } else {
                print("No data in the response")
            }
        }
    }
}

struct StoryCard: View {
    let story: Story
    @State private var isLiked: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var favoriteStoriesStore: FavoriteStoriesStore
    @State private var isExpanded: Bool = false

    init(story: Story) {
        self.story = story
        _isLiked = State(initialValue: story.isLiked ?? false)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(story.title)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .foregroundColor(colorScheme == .dark ? .green : .secondary)
                Spacer()
            }

            if isExpanded {
                Text(story.content)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                        .animation(
                                Animation
                                        .easeInOut(duration: 1.5)
                                        .repeatForever(autoreverses: true),
                                value: UUID()
                        ).onTapGesture {
                            isExpanded.toggle()
                        }
            } else {
                Text(story.content)
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .transition(.opacity)
                        .animation(
                                Animation
                                        .easeInOut(duration: 1.5),
                                value: UUID()
                        ).onTapGesture {
                            isExpanded.toggle()
                        }
            }

            HStack {
                Spacer()
                Button(action: {
                    isLoading = true
                    addToFavorites(id: story.id) { success in
                        if success {
                            isLoading = false
                            isLiked.toggle()
                            if isLiked {
                                favoriteStoriesStore.addToFavorites(story)
                            } else {
                                favoriteStoriesStore.removeFromFavorites(story)
                            }
                        } else {
                            isLoading = false
                        }
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .green : .gray)
                            .font(.system(size: 20))
                            .padding(8)
                }
                        .padding(8)
                        .disabled(isLoading)
            }
                    .cornerRadius(8)
                    .cornerRadius(10)
        }
                .padding(15)
                .background(colorScheme == .dark ? Color(.green) : Color.white)
                .frame(maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: colorScheme == .dark ? .white.opacity(0.01) : .green.opacity(0.1), radius: 15, x: 0, y: 5)
                .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.1), lineWidth: 1)
                )
    }
}

private func addToFavorites(id: Int, completion: @escaping (Bool) -> Void) {
    request(ADD_TO_FAVORITES_STORIES_ROUTE + String(id), method: "POST") { error in
        if let error = error {
            print("Error: \(error)")
            completion(false)
            return
        }
        completion(true)
    }
}
