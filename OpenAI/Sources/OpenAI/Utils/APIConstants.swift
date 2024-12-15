//
//  Constants.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

enum APIConstants {
   
   static let overrideBaseURL: String? = nil
   
   case thread
   case message
}

extension APIConstants: Endpoint {
   
   var base: String {
      Self.overrideBaseURL ?? "https://api.openai.com"
   }
   
   var path: String {
      switch self {
      case .thread: "/v1/threads"
      case .message: "/v1/messages"
      }
   }
}
