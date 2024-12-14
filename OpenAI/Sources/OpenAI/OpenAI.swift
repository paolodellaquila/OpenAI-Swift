//
//  OpenAI.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

public class OpenAI {
    private let threadManager: OpenAIThreadManager
    private let apiKey: String

    public init() {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("API Key not found. Please set 'OPENAI_API_KEY' in your environment variables.")
        }
        self.apiKey = apiKey
        self.threadManager = OpenAIThreadManagerImpl(apiKey: apiKey, apiURL: Constants.apiURL)
    }

    public func openThread() -> String {
        return threadManager.openThread()
    }

    public func sendRequest(threadId: String, prompt: String, images: [Data], completion: @Sendable @escaping (Result<[String: Any], Error>) -> Void) {
        threadManager.sendRequest(threadId: threadId, prompt: prompt, images: images, completion: completion)
    }

    public func closeThread(threadId: String) {
        threadManager.closeThread(threadId: threadId)
    }
}







