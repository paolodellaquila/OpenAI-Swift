//
//  Run.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

import Foundation

/// BETA.
/// A [run](https://platform.openai.com/docs/api-reference/runs) object, represents an execution run on a [thread](https://platform.openai.com/docs/api-reference/threads).
/// Related guide: [Assistants](https://platform.openai.com/docs/assistants/overview)
/// [Run Object](https://platform.openai.com/docs/api-reference/runs/object)
public struct Run: Decodable {
   
   /// The identifier, which can be referenced in API endpoints.
   public let id: String
   /// The object type, which is always thread.run.
   public let object: String
   /// The Unix timestamp (in seconds) for when the run was created.
   public let createdAt: Int?
   /// The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) that was executed on as a part of this run.
   public let threadID: String
   /// The ID of the [assistant](https://platform.openai.com/docs/api-reference/assistants) used for execution of this run.
   public let assistantID: String
   /// The status of the run, which can be either queued, in_progress, requires_action, cancelling, cancelled, failed, completed, or expired.
   public let status: String
   /// Details on the action required to continue the run. Will be null if no action is required.
   public let requiredAction: RequiredAction?
   /// The Unix timestamp (in seconds) for when the run will expire.
   public let expiresAt: Int?
   /// The Unix timestamp (in seconds) for when the run was started.
   public let startedAt: Int?
   /// The Unix timestamp (in seconds) for when the run was cancelled.
   public let cancelledAt: Int?
   /// The Unix timestamp (in seconds) for when the run failed.
   public let failedAt: Int?
   /// The Unix timestamp (in seconds) for when the run was completed.
   public let completedAt: Int?
   /// The model that the [assistant](https://platform.openai.com/docs/api-reference/assistants) used for this run.
   public let model: String
   /// The instructions that the [assistant](https://platform.openai.com/docs/api-reference/assistants) used for this run.
   public let instructions: String?
   /// Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.
   public let metadata: [String: String]
   /// The sampling temperature used for this run. If not set, defaults to 1.
   public let temperature: Double?
   /// The nucleus sampling value used for this run. If not set, defaults to 1.
   public let topP: Double?
   /// The maximum number of prompt tokens specified to have been used over the course of the run.
   public let maxPromptTokens: Int?
   /// The maximum number of completion tokens specified to have been used over the course of the run.
   public let maxCompletionTokens: Int?

   public enum Status: String {
      case queued
      case inProgress = "in_progress"
      case requiresAction = "requires_action"
      case cancelling
      case cancelled
      case failed
      case completed
      case expired
   }
   
   public struct RequiredAction: Decodable {
      
      /// For now, this is always submit_tool_outputs.
      public let type: String
      
      private enum CodingKeys: String, CodingKey {
         case type
      }
   }
   
   public var displayStatus: Status? { .init(rawValue: status) }
   
   private enum CodingKeys: String, CodingKey {
      case id
      case object
      case createdAt = "created_at"
      case threadID = "thread_id"
      case assistantID = "assistant_id"
      case status
      case requiredAction = "required_action"
      case expiresAt = "expires_at"
      case startedAt = "started_at"
      case cancelledAt = "cancelled_at"
      case failedAt = "failed_at"
      case completedAt = "completed_at"
      case model
      case instructions
      case metadata

      case temperature
      case topP = "top_p"
      case maxPromptTokens = "max_prompt_tokens"
      case maxCompletionTokens = "max_completion_tokens"
   }
    
   static func fromRunResponse(_ response: RunResponse) -> Run {
        Run(
            id: response.id,
            object: response.object,
            createdAt: response.createdAt,
            threadID: response.threadID,
            assistantID: response.assistantID,
            status: response.status,
            requiredAction: RequiredAction(type: "submit_tool_outputs"), ///fixed for now
            expiresAt: response.expiresAt,
            startedAt: response.startedAt,
            cancelledAt: response.cancelledAt,
            failedAt: response.failedAt,
            completedAt: response.completedAt,
            model: response.model,
            instructions: response.instructions,
            metadata: response.metadata,
            temperature: response.temperature,
            topP: response.topP,
            maxPromptTokens: response.maxPromptTokens,
            maxCompletionTokens: response.maxPromptTokens
        )
    }
    
    static func fromRunResponse(_ response: [RunResponse]) -> [Run] {
        response.map(fromRunResponse)
    }
}
