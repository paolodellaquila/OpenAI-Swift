//
//  ThreadManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation


/**
 Manages individual threads for OpenAI requests.
 */
protocol OpenAIService {
    

    //MARK: THREADS
    //[BETA]
    
    /**
     Opens a new thread and returns a unique thread ID.
     - Returns: A unique thread ID for the new thread.
    */
    func openThread() -> String
    
    /**
     Closes a thread by removing its context.

     - Parameter threadId: The unique thread ID to close.
    */
    func closeThread(threadId: String)
    
    
    //MARK: MESSAGES
    //[BETA]
    
    /**
     Sends a request to the OpenAI API within a specific thread.

     - Parameters:
       - threadId: The unique thread ID.
       - prompt: The prompt text to send.
       - images: An array of image data (base64 encoded) to include.
       - completion: A closure that handles the API response or error.
    */
    func createMessage(threadId: String, prompt: String, images: [Data], completion: @escaping @Sendable (Result<[String: Any], Error>) -> Void)
    

}
