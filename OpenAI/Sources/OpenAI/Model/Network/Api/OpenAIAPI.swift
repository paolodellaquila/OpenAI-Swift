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
    nonisolated(unsafe) static var assistanceBetaHeader: String = "assistants=v2"
    
    case thread(ThreadCategory)
    case message(MessageCategory)
    case run(RunCategory)
    case file(FileCategory)
    
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
    
    enum RunCategory {
        case create(threadID: String)
        case retrieve(threadID: String, runID: String)
        case modify(threadID: String, runID: String)
        case list(threadID: String)
        case cancel(threadID: String, runID: String)
        case submitToolOutput(threadID: String, runID: String)
        case createThreadAndRun
    }
    
    enum FileCategory {
       case list
       case upload
       case delete(fileID: String)
       case retrieve(fileID: String)
       case retrieveFileContent(fileID: String)
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
            case .create(let threadID): return "/\(version)/threads/\(threadID)/messages"
            case .list(let threadID): return "/\(version)/threads/\(threadID)/messages"
            case .retrieve(let threadID, let messageID), .modify(let threadID, let messageID), .delete(let threadID, let messageID): return "/\(version)/threads/\(threadID)/messages/\(messageID)"
         }
      case .run(let category):
         switch category {
             case .create(let threadID), .list(let threadID): return "/\(version)/threads/\(threadID)/runs"
             case .retrieve(let threadID, let runID), .modify(let threadID, let runID): return "/\(version)/threads/\(threadID)/runs/\(runID)"
             case .cancel(let threadID, let runID): return "/\(version)/threads/\(threadID)/runs/\(runID)/cancel"
             case .submitToolOutput(let threadID, let runID): return "/\(version)/threads/\(threadID)/runs/\(runID)/submit_tool_outputs"
             case .createThreadAndRun: return "/\(version)/threads/runs"
         }
      case .file(let category):
         switch category {
             case .list, .upload: return "/\(version)/files"
             case .delete(let fileID), .retrieve(let fileID): return "/\(version)/files/\(fileID)"
             case .retrieveFileContent(let fileID): return "/\(version)/files/\(fileID)/content"
         }
      }
   }
}
