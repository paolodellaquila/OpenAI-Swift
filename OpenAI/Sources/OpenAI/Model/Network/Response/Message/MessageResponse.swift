//
//  MessageResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


import Foundation

/// BETA.
/// Represents a [message](https://platform.openai.com/docs/api-reference/messages) within a [thread](https://platform.openai.com/docs/api-reference/threads).
/// [Message Object](https://platform.openai.com/docs/api-reference/messages/object)
public struct MessageResponse: Codable {
   
   /// The identifier, which can be referenced in API endpoints.
   public let id: String
   /// The object type, which is always thread.message.
   public let object: String
   /// The Unix timestamp (in seconds) for when the message was created.
   public let createdAt: Int
   /// The [thread](https://platform.openai.com/docs/api-reference/threads) ID that this message belongs to.
   public let threadID: String
   /// The entity that produced the message. One of user or assistant.
   public let role: String
   /// The content of the message in array of text and/or images.
    public let content: [MessageContentResponse]
   /// If applicable, the ID of the [assistant](https://platform.openai.com/docs/api-reference/assistants) that authored this message.
   public let assistantID: String?
   /// If applicable, the ID of the [run](https://platform.openai.com/docs/api-reference/runs) associated with the authoring of this message.
   public let runID: String?
   /// A list of files attached to the message, and the tools they were added to.
   public let attachments: [MessageAttachmentResponse]?
   /// Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
   public let metadata: [String: String]?
   
   enum Role: String {
      case user
      case assistant
   }
   
   enum CodingKeys: String, CodingKey {
       case id
       case object
       case createdAt = "created_at"
       case assistantID = "assistant_id"
       case threadID = "thread_id"
       case runID = "run_id"
       case role
       case content
       case attachments
       case metadata
   }
   
   public init(
      id: String,
      object: String,
      createdAt: Int,
      threadID: String,
      role: String,
      content: [MessageContentResponse],
      assistantID: String?,
      runID: String?,
      attachments: [MessageAttachmentResponse]?,
      metadata: [String : String]?)
   {
      self.id = id
      self.object = object
      self.createdAt = createdAt
      self.threadID = threadID
      self.role = role
      self.content = content
      self.assistantID = assistantID
      self.runID = runID
      self.attachments = attachments
      self.metadata = metadata
   }
}
