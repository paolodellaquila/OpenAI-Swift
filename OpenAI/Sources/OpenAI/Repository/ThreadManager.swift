//
//  ThreadManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

protocol OpenAIThreadManager {
    
    func openThread() -> String
    func sendRequest(threadId: String, prompt: String, images: [Data], completion: @escaping @Sendable (Result<[String: Any], Error>) -> Void)
    func closeThread(threadId: String)
}
