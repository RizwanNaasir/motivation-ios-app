//
// Created by InterLink on 7/7/23.
//

import Foundation

struct Goal: Identifiable, Codable, Hashable {
    var id: Int? = nil
    var title: String
    var description: String
    let createdAt: String? = nil
    let updatedAt: String? = nil
    // Add other properties as needed

    enum CodingKeys: String, CodingKey {
        case
                id,
                title,
                description,
                createdAt = "created_at",
                updatedAt = "updated_at"
    }

    static func from(_ goal: Goal?) -> Goal {
        Goal(
                id: goal?.id,
                title: goal?.title ?? "",
                description: goal?.description ?? ""
        )
    }
}