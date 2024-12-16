//
//  SharedService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


import Foundation

public protocol CacheService {
    
    ///Cache Thread retrieved from API
    func saveThread(_ thread: AIThread) throws
    
    ///Delete specific thread from cache
    func deleteThread(_ threadId: String) throws
    
    ///Fetch cached Threads
    func fetchThreads() throws -> [AIThread]
    
    ///Save a new message into specific thread
    func saveMessages(for threadId: String, messages: [Message]) throws
    
    ///Delete all message for a specific thread
    func deleteMessages(for threadId: String) throws
    
    ///Fetch cached messafges for a thread
    func fetchMessages(for threadId: String) throws -> [Message]
}
