//
//  MessageResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


struct MessageResponse: Codable {
    let id, object: String
    let createdAt: Int
    let assistantID: String?
    let threadID: String
    let runID: String?
    let role: String
    let content: [ContentResponse]
    let attachments: [AttachmentResponse]

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
        case assistantID = "assistant_id"
        case threadID = "thread_id"
        case runID = "run_id"
        case role, content, attachments
    }
}

struct ContentResponse: Codable {
    let type: String
    let text: TextResponse
}

struct TextResponse: Codable {
    let value: String
}

struct AttachmentResponse: Codable {
    let fileID: String
    
    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
    }
}
