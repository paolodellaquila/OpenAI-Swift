//
//  FileRequest.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

// MARK: - RunRequest
struct RunRequest: Codable {
    let assistantId: String
    let stream: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case assistantId = "assistant_id"
        case stream
    }
}
