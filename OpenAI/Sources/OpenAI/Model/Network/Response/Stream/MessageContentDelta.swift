//
//  MessageContent.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//

import Foundation
///  The [content](https://platform.openai.com/docs/api-reference/messages/object#messages/object-content) of the message in array of text and/or images.
public enum MessageContentDelta: Codable {
   
   case imageFile(ImageFileDelta)
   case text(TextDelta)
   
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
       let imageFile = try ImageFileDelta(from: decoder)
         self = .imageFile(imageFile)
      case "text":
         let text = try TextDelta(from: decoder)
         self = .text(text)
      default:
         throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for content")
      }
   }
}

// MARK: Image File

public struct ImageFileDelta: Codable {
   /// Always image_file.
   public let type: String
   
   /// References an image [File](https://platform.openai.com/docs/api-reference/files) in the content of a message.
   public let imageFile: ImageFileContentDelta
   
   public struct ImageFileContentDelta: Codable {
      
      /// The [File](https://platform.openai.com/docs/api-reference/files) ID of the image in the message content.
      public let fileID: String
      
      enum CodingKeys: String, CodingKey {
         case fileID = "file_id"
      }
   }
   
   enum CodingKeys: String, CodingKey {
      case imageFile = "image_file"
      case type
   }
}

// MARK: Text

public struct TextDelta: Codable {
   
   /// Always text.
   public let type: String
   /// The text content that is part of a message.
   public let text: TextContentDelta
   
   public struct TextContentDelta: Codable {
      // The data that makes up the text.
      public let value: String
      
      public let annotations: [AnnotationDelta]?
   }
}

// MARK: Annotation

public enum AnnotationDelta: Codable {
   
   case fileCitation(FileCitationDelta)
   case filePath(FilePathDelta)
   
   enum CodingKeys: String, CodingKey {
      case type
      case text
      case fileCitation = "file_citation"
      case filePath = "file_path"
      case startIndex = "start_index"
      case endIndex = "end_index"
   }
   
   enum AnnotationTypeKey: CodingKey {
      case type
   }
   
   public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      switch self {
      case .fileCitation(let fileCitation):
         try container.encode("file_citation", forKey: .type)
         try container.encode(fileCitation, forKey: .fileCitation)
      case .filePath(let filePath):
         try container.encode("file_path", forKey: .type)
         try container.encode(filePath, forKey: .filePath)
      }
   }
   
   public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: AnnotationTypeKey.self)
      let type = try container.decode(String.self, forKey: .type)
      switch type {
      case "file_citation":
         let fileCitationContainer = try decoder.container(keyedBy: CodingKeys.self)
         let fileCitation = try fileCitationContainer.decode(FileCitationDelta.self, forKey: .fileCitation)
         self = .fileCitation(fileCitation)
      case "file_path":
         let filePathContainer = try decoder.container(keyedBy: CodingKeys.self)
         let filePath = try filePathContainer.decode(FilePathDelta.self, forKey: .filePath)
         self = .filePath(filePath)
      default:
         throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid type for annotation")
      }
   }
}

// MARK: FileCitation

/// A citation within the message that points to a specific quote from a specific File associated with the assistant or the message. Generated when the assistant uses the "retrieval" tool to search files.
public struct FileCitationDelta: Codable {
   
   /// Always file_citation, except when using Assistants API Beta, e.g. when using file_store search
   public let type: String?
   /// The text in the message content that needs to be replaced. Not always present with Assistants API Beta, e.g. when using file_store search
   public let text: String?
   public let fileCitation: FileCitationDetailsDelta?
   public let startIndex: Int?
   public let endIndex: Int?
   
   public struct FileCitationDetailsDelta: Codable {
      
      /// The ID of the specific File the citation is from.
      public let fileID: String
      /// The specific quote in the file.
      public let quote: String
      
      enum CodingKeys: String, CodingKey {
         case fileID = "file_id"
         case quote
      }
   }
   
   enum CodingKeys: String, CodingKey {
      case type
      case text
      case fileCitation = "file_citation"
      case startIndex = "start_index"
      case endIndex = "end_index"
   }
}

// MARK: FilePath

/// A URL for the file that's generated when the assistant used the code_interpreter tool to generate a file.
public struct FilePathDelta: Codable {
   
   /// Always file_path
   public let type: String
   /// The text in the message content that needs to be replaced.
   public let text: String
   public let filePath: FilePathDetailsDelta
   public let startIndex: Int
   public let endIndex: Int
   
   public struct FilePathDetailsDelta: Codable {
      /// The ID of the file that was generated.
      public let fileID: String
      
      enum CodingKeys: String, CodingKey {
         case fileID = "file_id"
      }
   }
   
   enum CodingKeys: String, CodingKey {
      case type
      case text
      case filePath = "file_path"
      case startIndex = "start_index"
      case endIndex = "end_index"
   }
}
