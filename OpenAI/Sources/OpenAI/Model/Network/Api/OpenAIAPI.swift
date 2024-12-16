//
//  Constants.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

enum OpenAIAPI {
   
   nonisolated(unsafe) static var overrideBaseURL: String? = nil
   nonisolated(unsafe) static var overrideVersion: String? = nil
   
   case thread(ThreadCategory)
   case message(MessageCategory)
    
    enum ThreadCategory {
       case create
       case retrieve(threadID: String)
       case modify(threadID: String)
       case delete(threadID: String)
    }
    
    enum MessageCategory {
       case create(threadID: String)
       case retrieve(threadID: String, messageID: String)
       case modify(threadID: String, messageID: String)
       case delete(threadID: String, messageID: String)
       case list(threadID: String)
    }
}

extension OpenAIAPI: Endpoint {
   
   var base: String {
       Self.overrideBaseURL ?? "https://api.openai.com"
   }
    
    var version: String {
       Self.overrideVersion ?? "v1"
    }
   
   var path: String {
      switch self {
      case .thread(let category):
         switch category {
             case .create: return "/\(version)/threads"
             case .retrieve(let threadID), .modify(let threadID), .delete(let threadID): return "/\(version)/threads/\(threadID)"
         }
      case .message(let category):
         switch category {
            case .create(let threadID), .list(let threadID): return "/\(version)/threads/\(threadID)/messages"
            case .retrieve(let threadID, let messageID), .modify(let threadID, let messageID), .delete(let threadID, let messageID): return "/\(version)/threads/\(threadID)/messages/\(messageID)"
         }
      }
   }
}
