//
//  ImageFile.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


// MARK: Image File

public struct ImageFileResponse: Codable {
   /// Always image_file.
   public let type: String
   
   /// References an image [File](https://platform.openai.com/docs/api-reference/files) in the content of a message.
   public let imageFile: ImageFileContent
   
   public struct ImageFileContent: Codable {
      
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
