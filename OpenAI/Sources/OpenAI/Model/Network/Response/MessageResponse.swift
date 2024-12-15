//
//  MessageResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


struct MessageResponse: Codable {
    let id, object: String
    let createdAt: Int
    let assistantID: JSONNull?
    let threadID: String
    let runID: JSONNull?
    let role: String
    let content: [Content]
    let attachments: [JSONAny]
    let metadata: Metadata

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
        case assistantID = "assistant_id"
        case threadID = "thread_id"
        case runID = "run_id"
        case role, content, attachments, metadata
    }
}