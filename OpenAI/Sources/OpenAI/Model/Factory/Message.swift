//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct Message {
    let id, object: String
    let createdAt: Int
    let assistantID: String?
    let threadID: String
    let runID: String?
    let role: String
    let content: [Content]
    let attachments: [Attachment]
    
    static func fromMessageResponse(_ response: MessageResponse) -> Message {
        Message.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: response.content, attachments: response.attachments)
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [Message] {
        response.map(Message.fromMessageResponse)
    }
}

public struct Content: Decodable {
    let type: String
    let text: Text
    
    static func fromMessageResponse(_ response: ContentResponse) -> Content {
        Content(type: response.type, text: response.text)
    }
}

public struct Text: Decodable {
    let value: String
    
    static func fromTextResponse(_ response: TextResponse) -> Text {
        Text(value: response.value)
    }
}

public struct Attachment: Decodable {
    let fileID: String
    
    static func fromAttachamentResponse(_ response: AttachmentResponse) -> Attachment {
        Attachment(fileID: response.fileID)
    }
}
