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
        Message.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: Content.fromContentResponse(response.content), attachments: Attachment.fromAttachamentResponse(response.attachments))
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [Message] {
        response.map(Message.fromMessageResponse)
    }
}

public struct Content {
    let type: String
    let text: Text
    
    static func fromContentResponse(_ response: [ContentResponse]) -> [Content] {
        response.map { Content(type: $0.type, text: Text(value: $0.text.value)) }
    }
}

public struct Text {
    let value: String
    
    static func fromTextResponse(_ response: TextResponse) -> Text {
        Text(value: response.value)
    }
}

public struct Attachment {
    let fileID: String
    
    static func fromAttachamentResponse(_ response: [AttachmentResponse]) -> [Attachment] {
        response.map { Attachment(fileID: $0.fileID) }
    }
}
