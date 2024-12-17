//
//  FileRequest.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

struct MessageRequest: Codable {
    let id, object: String
    let createdAt: Int
    let assistantID: String?
    let threadID: String
    let runID: String?
    let role: String
    let content: [ContentRequest]
    let attachments: [AttachmentRequest]

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
        case assistantID = "assistant_id"
        case threadID = "thread_id"
        case runID = "run_id"
        case role, content, attachments
    }
}

// MARK: - Content
struct ContentRequest: Codable {
    let type: String
    let text: TextRequest
}

// MARK: - Text
struct TextRequest: Codable {
    let value: String
}

// MARK: - Attachment
struct AttachmentRequest: Codable {
    let fileId: String
    
    enum CodingKeys: String, CodingKey {
        case fileId = "file_id"
    }
}
