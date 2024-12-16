//
//  FileRequest.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


struct FileRequest: Codable {
    let id, object: String
    let bytes, createdAt: Int
    let filename, purpose: String

    enum CodingKeys: String, CodingKey {
        case id, object, bytes
        case createdAt = "created_at"
        case filename, purpose
    }
}
