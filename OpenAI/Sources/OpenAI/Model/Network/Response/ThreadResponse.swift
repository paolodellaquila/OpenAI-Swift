//
//  ThreadResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


struct ThreadResponse: Codable {
    let id, object: String
    let createdAt: Int
    let deleted: Bool?

    enum CodingKeys: String, CodingKey {
        case id, object, deleted
        case createdAt = "created_at"
    }
}
