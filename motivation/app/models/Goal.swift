//
// Created by InterLink on 7/7/23.
//

import Foundation

struct Goal: Identifiable, Codable, Hashable {
    let id: Int? = nil
    let title: String
    let description: String
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
}