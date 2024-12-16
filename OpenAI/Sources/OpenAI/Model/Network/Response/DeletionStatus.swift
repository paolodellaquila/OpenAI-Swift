//
//  DeletionStatus.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

/// The [Deletation generic object](eg. https://platform.openai.com/docs/api-reference/threads/deleteThread) represents a generic deletion response from OpenAI.
public struct DeletionStatus: Codable {
   public let id: String
   public let object: String
   public let deleted: Bool
}
