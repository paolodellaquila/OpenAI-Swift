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
    private let threadManager: OpenAIThreadManager
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
        self.threadManager = OpenAIThreadManagerImpl(apiKey: apiKey)
    }

    /**
     Opens a new thread for sending requests.

     - Returns: A unique thread ID for the new thread.
    */
    public func openThread() -> String {
        return threadManager.openThread()
    }

    /**
     Sends a request to the OpenAI API in the context of a specific thread.

     - Parameters:
       - threadId: The unique thread ID.
       - prompt: The prompt text to send to OpenAI.
       - images: An array of image data to include in the request.
       - completion: A closure called with the result of the request.
    */
    public func sendRequest(threadId: String, prompt: String, images: [Data], completion: @Sendable @escaping (Result<[String: Any], Error>) -> Void) {
        threadManager.sendRequest(threadId: threadId, prompt: prompt, images: images, completion: completion)
    }

    /**
     Closes a thread and removes its context.

     - Parameter threadId: The unique thread ID to close.
    */
    public func closeThread(threadId: String) {
        threadManager.closeThread(threadId: threadId)
    }
}







