//
//  MessageContent.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

import Foundation

///  The [content](https://platform.openai.com/docs/api-reference/messages/object#messages/object-content) of the message in array of text and/or images.
public enum MessageContentResponse: Codable {
   
    case imageFile(ImageFileResponse)
    case text(TextResponse)
   
   enum CodingKeys: String, CodingKey {
      case type
      case imageFile = "image_file"
      case text
   }
   
   enum ContentTypeKey: CodingKey {
      case type
   }
   
   public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .imageFile(let imageFile):
         try container.encode("image_file", forKey: .type)
         try container.encode(imageFile, forKey: .imageFile)
      case .text(let text):
         try container.encode("text", forKey: .type)
         try container.encode(text, forKey: .text)
      }
   }
   
   public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: ContentTypeKey.self)
      let type = try container.decode(String.self, forKey: .type)
      
      switch type {
      case "image_file":
          let imageFile = try ImageFileResponse(from: decoder)
         self = .imageFile(imageFile)
      case "text":
          let text = try TextResponse(from: decoder)
         self = .text(text)
      default:
         throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for content")
      }
   }
}
