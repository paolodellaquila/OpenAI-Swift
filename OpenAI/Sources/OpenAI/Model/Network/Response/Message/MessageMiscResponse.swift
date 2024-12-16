//
//  Text.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


public struct TextResponse: Codable {
   
   /// Always text.
   public let type: String
   /// The text content that is part of a message.
   public let text: TextContent
   
   public struct TextContent: Codable {
      // The data that makes up the text.
      public let value: String
   }
}
