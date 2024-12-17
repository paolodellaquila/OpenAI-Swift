//
//  FileRequest.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

// MARK: - MessageRequest
struct MessageRequest: Codable {
    let role: String
    let content: [MessageContentRequest]
    
    enum CodingKeys: String, CodingKey {
        case role, content
    }
}

// MARK: - MessageContentRequest
struct MessageContentRequest: Codable {
    let type: String
    let text: String?
    let imageFile: ImageFileContentRequest?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageFile = "image_file"
    }
    
    // Factory methods for cleaner content creation
    static func textContent(_ value: String) -> MessageContentRequest {
        return MessageContentRequest(type: "text", text: value, imageFile: nil)
    }
    
    static func imageContent(fileId: String) -> MessageContentRequest {
        return MessageContentRequest(type: "image_file", text: nil, imageFile: ImageFileContentRequest(fileId: fileId))
    }
}

// MARK: - ImageFileContentRequest
struct ImageFileContentRequest: Codable {
    let fileId: String
    
    enum CodingKeys: String, CodingKey {
        case fileId = "file_id"
    }
}
