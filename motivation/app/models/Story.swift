//
// Created by InterLink on 7/3/23.
//

import Foundation

struct Story: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let content: String
    let createdAt: String?
    let updatedAt: String?
    var isLiked: Bool?

    enum CodingKeys: String, CodingKey {
        case id,
             title,
             content,
             updatedAt = "updated_at",
             createdAt = "created_at",
             isLiked = "is_liked"
    }
}
