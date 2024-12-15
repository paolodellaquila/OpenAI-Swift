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
     Create a new thread.
     https://platform.openai.com/docs/api-reference/threads/createThread
     - Returns: A Thread Object -> https://platform.openai.com/docs/api-reference/threads/object
    */
    func openThread() async throws -> AIThread
    
    /**
     Delete a thread.
     https://platform.openai.com/docs/api-reference/threads/deleteThread
     
     - Parameter threadId: The unique thread ID to close.
     - Returns: A Boolean that indicates if thread is correctly deleted.
     - Response:  A Thread Object -> https://platform.openai.com/docs/api-reference/threads/object
    */
    func deleteThread(threadId: String) async throws -> Bool
    
    
    //MARK: MESSAGES
    //[BETA]
    
    /**
     Sends a request to the OpenAI API within a specific thread and return a list of attached messafe
     https://platform.openai.com/docs/api-reference/messages/listMessages
     
     - Parameters:
       - threadId: The unique thread ID.
       - Returns: A Message Object -> https://platform.openai.com/docs/api-reference/messages/object
    */
    func listMessages(threadId: String) async throws -> [AIMessage]
    
    /**
     Sends a request to the OpenAI API within a specific thread and create a new attached message
     https://platform.openai.com/docs/api-reference/messages/createMessage

     - Parameters:
       - threadId: The unique thread ID.
       - prompt: The prompt text to send.
       - images: An array of image data (base64 encoded) to include.
       - Returns: A Message Object -> https://platform.openai.com/docs/api-reference/messages/object
    */
    func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> AIMessage
    

}
