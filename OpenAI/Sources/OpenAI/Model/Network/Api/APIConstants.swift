//
//  Constants.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

enum APIConstants {
   
   nonisolated(unsafe) static var overrideBaseURL: String? = nil
   
   case thread
   case message(threadId: String)
}

extension APIConstants: Endpoint {
   
   var base: String {
      Self.overrideBaseURL ?? "https://api.openai.com"
   }
   
   var path: String {
      switch self {
      case .thread: "/v1/threads"
      case .message(let threadId): "/v1/\(threadId)/messages"
      }
   }
}
