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
public protocol OpenAIService {

    //MARK: THREADS [BETA]
    /**
     Create a new thread.
     https://platform.openai.com/docs/api-reference/threads/createThread
     - Returns: A Thread Object -> https://platform.openai.com/docs/api-reference/threads/object
    */
    func openThread() async throws -> AIThread
    
    /**
     List previous cached opened thread.
     - Returns: A Thread Object -> https://platform.openai.com/docs/api-reference/threads/object
    */
    func fetchThreads() async throws -> [AIThread]
    
    /**
     Delete a thread.
     https://platform.openai.com/docs/api-reference/threads/deleteThread
     
     - Parameter threadId: The unique thread ID to close.
     - Returns: A Boolean that indicates if thread is correctly deleted.
     - Response:  A Thread Object -> https://platform.openai.com/docs/api-reference/threads/object
    */
    func deleteThread(threadId: String) async throws -> Bool
    
    
    //MARK: MESSAGES [BETA]
    
    /**
     Sends a request to the OpenAI API within a specific thread and return a list of attached messafe
     https://platform.openai.com/docs/api-reference/messages/listMessages
     
     - Parameters:
       - threadId: The unique thread ID.
       - Returns: A Message Object -> https://platform.openai.com/docs/api-reference/messages/object
    */
    func fetchMessages(threadId: String) async throws -> [Message]
    
    /**
     Sends a request to the OpenAI API within a specific thread and create a new attached message
     https://platform.openai.com/docs/api-reference/messages/createMessage

     - Parameters:
       - threadId: The unique thread ID.
       - prompt: The prompt text to send.
       - images: An array of image data (base64 encoded) to include.
       - Returns: A Message Object -> https://platform.openai.com/docs/api-reference/messages/object
    */
    func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> Message
    
    // MARK: -- Run [BETA]
    /**
     Sends a request to the OpenAI API to run a specific thread
     https://platform.openai.com/docs/api-reference/runs

     - Parameters:
       - threadId: The unique thread ID.
       - Returns: A Run Object -> https://platform.openai.com/docs/api-reference/runs/object
    */
    func createRun(threadId: String) async throws -> Run
    
    /**
     Sends a request to the OpenAI API to return a list of Run
     https://platform.openai.com/docs/api-reference/runs

     - Parameters:
       - threadId: The unique thread ID.
       - limit: list limit
       - order: ASC or DESC
       - after: timestamp
       - before: timestamp
       - Returns: A Run Object -> https://platform.openai.com/docs/api-reference/runs/object
    */
    func fetchRuns(threadId: String, limit: Int?, order: String?, after: String?, before: String?) async throws -> [Run]
    
    //MARK: -- File [BETA]
    /**
     Sends a request to the OpenAI API to return a list of Run
     https://platform.openai.com/docs/api-reference/files

     - Parameters:
       - Returns: A File Object -> https://platform.openai.com/docs/api-reference/files/object
    */
    func fetchFiles() async throws -> [File]
    
    // MARK: -- Upload [BETA]
    /**
     Sends a request to the OpenAI API to return a list of Run
     https://platform.openai.com/docs/api-reference/uploads

     - Parameters:
       - params: FileParameters -> https://platform.openai.com/docs/api-reference/uploads/part-object
       - Returns: A File Object -> https://platform.openai.com/docs/api-reference/files/object
    */
    func uploadFile(params: FileParameters) async throws -> File

}
