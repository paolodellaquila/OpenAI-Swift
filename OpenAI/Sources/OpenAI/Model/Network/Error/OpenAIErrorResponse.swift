//
//  OpenAIErrorResponse.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct OpenAIErrorResponse: Decodable {
   
   public let error: Error
   
   public struct Error: Decodable {
      public let message: String?
      public let type: String?
      public let param: String?
      public let code: String?
   }
}