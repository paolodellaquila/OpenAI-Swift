//
//  MessageAttachment.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

/// Messages have attachments instead of file_ids. attachments are helpers that add files to the Thread’s tool_resources.
/// [V2](https://platform.openai.com/docs/assistants/migration/what-has-changed)
public struct MessageAttachmentResponse: Codable {

   let fileID: String
   
   enum CodingKeys: String, CodingKey {
      case fileID = "file_id"
   }
   
   public init(fileID: String) {
       self.fileID = fileID
   }
}
