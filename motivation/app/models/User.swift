//
// Created by InterLink on 7/3/23.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: Int
    let name: String?
    let surname: String?
    let email: String
    let age: Int?
    let gender: String?
    let favouriteHobby: String?
    let personaltyType: String?

    enum CodingKeys: String, CodingKey {
        case
                id,
                name,
                surname,
                email,
                age,
                gender,
                favouriteHobby = "favourite_hobby",
                personaltyType = "personalty_type"
    }
}
