//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct AIMessage {
    let id, object: String
    let createdAt: Int
    let assistantID: String?
    let threadID: String
    let runID: String?
    let role: String
    let content: [AIContent]
    let attachments: [AIAttachment]
    
    static func fromMessageResponse(_ response: MessageResponse) -> AIMessage {
        AIMessage.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: AIContent.fromContentResponse(response.content), attachments: AIAttachment.fromAttachamentResponse(response.attachments))
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [AIMessage] {
        response.map(AIMessage.fromMessageResponse)
    }
}

public struct AIContent {
    let type: String
    let text: AIText
    
    static func fromContentResponse(_ response: [ContentResponse]) -> [AIContent] {
        response.map { AIContent(type: $0.type, text: AIText(value: $0.text.value)) }
    }
}

public struct AIText {
    let value: String
    
    static func fromTextResponse(_ response: TextResponse) -> AIText {
        AIText(value: response.value)
    }
}

public struct AIAttachment {
    let fileID: String
    
    static func fromAttachamentResponse(_ response: [AttachmentResponse]) -> [AIAttachment] {
        response.map { AIAttachment(fileID: $0.fileID) }
    }
}
