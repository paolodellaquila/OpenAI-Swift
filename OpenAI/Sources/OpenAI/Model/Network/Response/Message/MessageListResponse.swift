//
//  MessageListResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//


public struct MessageListResponse: Codable {
    public let object: String
    public let data: [MessageResponse]
    public let firstID: String
    public let lastID: String
    public let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case object
        case data
        case firstID = "first_id"
        case lastID = "last_id"
        case hasMore = "has_more"
    }
}
