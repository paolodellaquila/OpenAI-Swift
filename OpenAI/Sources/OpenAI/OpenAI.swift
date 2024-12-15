//
//  OpenAI.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

/**
 Main class for interacting with OpenAI services. This class acts as a high-level interface, exposing useful methods for managing threads and sending requests.
 */
public class OpenAI {
    private let aiService: OpenAIService
    private let apiKey: String

    /**
     Initializes the OpenAI client. It retrieves the API key from environment variables.

     - Throws: A fatal error if the API key is not set in the environment variables.
    */
    public init() {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("API Key not found. Please set 'OPENAI_API_KEY' in your environment variables.")
        }
        self.apiKey = apiKey
        self.aiService = OpenAIServiceImpl(apiKey: apiKey)
    }

    //MARK: -- Threads
    public func openThread() async throws-> AIThread {
        return try await aiService.openThread()
    }
    public func deleteThread(threadId: String) async throws -> Bool {
        return try await aiService.deleteThread(threadId: threadId)
    }

    //MARK: -- Message
    public func listMessages(threadId: String) async throws -> [AIMessage] {
        return try await aiService.listMessages(threadId: threadId)
    }
    public func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> AIMessage {
        return try await aiService.createMessage(threadId: threadId, prompt: prompt, images: images)
    }


}







