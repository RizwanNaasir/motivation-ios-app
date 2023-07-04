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
}
