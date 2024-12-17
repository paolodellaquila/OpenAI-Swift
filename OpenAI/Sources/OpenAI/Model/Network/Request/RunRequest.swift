//
//  FileRequest.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

// MARK: - RunRequest
struct RunRequest: Codable {
    let assistantId: String
    
    enum CodingKeys: String, CodingKey {
        case assistantId = "assistant_id"
    }
}
