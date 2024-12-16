//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct Message: Codable {
   public let id, object: String
   public let createdAt: Int
   public let assistantID: String?
   public let threadID: String
   public let runID: String?
   public let role: String
   public let content: [MessageContent]
   public let attachments: [Attachment]
    
    static func fromMessageResponse(_ response: MessageResponse) -> Message {
        Message.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: MessageContent.fromContentResponse(response.content), attachments: Attachment.fromAttachamentResponse(response.attachments ?? []))
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [Message] {
        response.map(Message.fromMessageResponse)
    }
}

public struct MessageContent: Codable {
    public let imageFile: ImageFile?
    public let text: Text?
    
    static func fromContentResponse(_ response: [MessageContentResponse]) -> [MessageContent] {
        response.map {
            switch $0 {
            case .imageFile(let response):
                MessageContent(imageFile: ImageFile.fromImageFileResponse(response), text: nil)
            case .text(let response):
                MessageContent(imageFile: nil, text: Text.fromTextResponse(response))
            }
        }
    }
}

public struct ImageFile: Codable {
   public let type: String
   public let imageFile: ImageFileContent
   
   public struct ImageFileContent: Codable {
      public let fileID: String
   }
    
    static func fromImageFileResponse(_ response: ImageFileResponse) -> ImageFile {
        ImageFile(type: response.type, imageFile: ImageFileContent(fileID: response.imageFile.fileID))
    }

}

public struct Text: Codable {
   public let type: String
   public let text: TextContent
   
    public struct TextContent: Codable {
      public let value: String
   }
    
    static func fromTextResponse(_ response: TextResponse) -> Text {
        Text(type: response.type, text: TextContent(value: response.text.value))
    }
}

public struct Attachment: Codable {
    public let fileID: String
    
    static func fromAttachamentResponse(_ response: [MessageAttachmentResponse]) -> [Attachment] {
        response.map { Attachment(fileID: $0.fileID) }
    }
}
