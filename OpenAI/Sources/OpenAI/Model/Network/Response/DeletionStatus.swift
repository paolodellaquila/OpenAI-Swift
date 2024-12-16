//
//  DeletionStatus.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


public struct DeletionStatus: Decodable {
   public let id: String
   public let object: String
   public let deleted: Bool
}