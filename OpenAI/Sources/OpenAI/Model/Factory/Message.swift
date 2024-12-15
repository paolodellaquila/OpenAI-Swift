//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct AIMessage {
   public let id, object: String
   public let createdAt: Int
   public let assistantID: String?
   public let threadID: String
   public let runID: String?
   public let role: String
   public let content: [AIContent]
   public let attachments: [AIAttachment]
    
    static func fromMessageResponse(_ response: MessageResponse) -> AIMessage {
        AIMessage.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: AIContent.fromContentResponse(response.content), attachments: AIAttachment.fromAttachamentResponse(response.attachments))
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [AIMessage] {
        response.map(AIMessage.fromMessageResponse)
    }
}

public struct AIContent {
    public let type: String
    public let text: AIText
    
    static func fromContentResponse(_ response: [ContentResponse]) -> [AIContent] {
        response.map { AIContent(type: $0.type, text: AIText(value: $0.text.value)) }
    }
}

public struct AIText {
    public let value: String
    
    static func fromTextResponse(_ response: TextResponse) -> AIText {
        AIText(value: response.value)
    }
}

public struct AIAttachment {
    public let fileID: String
    
    static func fromAttachamentResponse(_ response: [AttachmentResponse]) -> [AIAttachment] {
        response.map { AIAttachment(fileID: $0.fileID) }
    }
}
