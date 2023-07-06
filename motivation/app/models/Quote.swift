//
// Created by InterLink on 7/3/23.
//

import Foundation

struct Quote: Identifiable, Codable, Hashable {
    let id: Int
    let content: String
    let author: String
    let tags: [String]?
    let authorSlug: String?
    let length: Int?
    let createdAt: String?
    let updatedAt: String?
    var isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case id, content, author, tags, authorSlug = "author_slug", length, createdAt = "created_at", updatedAt = "updated_at", isLiked = "is_liked"
    }
}
