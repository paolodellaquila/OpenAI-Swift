//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation

public struct Message: Codable, Equatable {
   public let id, object: String
   public let createdAt: Int
   public let assistantID: String?
   public let threadID: String
   public let runID: String?
   public let role: String
   public let content: [MessageContent]
   public let attachments: [Attachment]
    
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.object == rhs.object &&
        lhs.createdAt == rhs.createdAt &&
        lhs.assistantID == rhs.assistantID &&
        lhs.threadID == rhs.threadID &&
        lhs.runID == rhs.runID &&
        lhs.role == rhs.role &&
        lhs.content.count == rhs.content.count &&
        lhs.attachments.count == rhs.attachments.count
    }
    
    static func fromMessageResponse(_ response: MessageResponse) -> Message {
        Message.init(id: response.id, object: response.object, createdAt: response.createdAt, assistantID: response.assistantID, threadID: response.threadID, runID: response.runID, role: response.role, content: MessageContent.fromContentResponse(response.content), attachments: Attachment.fromAttachamentResponse(response.attachments ?? []))
    }
    
    static func fromMessageResponse(_ response: [MessageResponse]) -> [Message] {
        response.map(Message.fromMessageResponse)
    }
}

public struct MessageContent: Codable {
    public let id: String = UUID().uuidString
    public let imageFile: ImageFile?
    public let text: Text?
    public let type: ContentType?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageFile = "image_file"
    }

    public enum ContentType: String, Codable {
        case text
        case imageFile = "image_file"
    }
    
    public init (text: Text?, imageFile: ImageFile?, type: ContentType?) {
        self.text = text
        self.imageFile = imageFile
        self.type = type
    }
    
    // Custom decoder to parse `text` or `image_file` dynamically
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode the content type
        let type = try container.decode(ContentType.self, forKey: .type)
        
        switch type {
        case .text:
            self.text = try container.decode(Text.self, forKey: .text)
            self.imageFile = nil
            self.type = .text
        case .imageFile:
            self.imageFile = try container.decode(ImageFile.self, forKey: .imageFile)
            self.text = nil
            self.type = .imageFile
        }
    }
    
    static func fromContentResponse(_ response: [MessageContentResponse]) -> [MessageContent] {
        response.map {
            switch $0.type {
            case .imageFile:
                MessageContent(text: nil, imageFile: ImageFile.fromImageFileResponse($0.imageFile!), type: .imageFile)
            case .text:
                MessageContent(text: Text.fromTextResponse($0.text!), imageFile: nil, type: .text)
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
    
    static func fromImageFileResponse(_ response: ImageFileContentResponse) -> ImageFile {
        ImageFile(type: "image_file", imageFile: ImageFileContent(fileID: response.fileID))
    }

}

public struct Text: Codable {
   public let type: String
   public let text: TextContent
   
    public struct TextContent: Codable {
      public let value: String
   }
    
    static func fromTextResponse(_ response: TextContentResponse) -> Text {
        Text(type: "text", text: TextContent(value: response.value))
    }
}

public struct Attachment: Codable {
    public let fileID: String
    
    static func fromAttachamentResponse(_ response: [MessageAttachmentResponse]) -> [Attachment] {
        response.map { Attachment(fileID: $0.fileID) }
    }
}
