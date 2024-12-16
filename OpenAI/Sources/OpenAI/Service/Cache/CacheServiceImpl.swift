//
//  SharedServiceImpl.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


import Foundation

class CacheServiceImpl: CacheService {
    private let threadsKey = "savedThreads"
    private let messagesKeyPrefix = "messages_"
    private let userDefaults = UserDefaults.standard
    
    func saveThread(_ thread: AIThread) throws {
        var threads = try fetchThreads()
        if !threads.contains(where: { $0.id == thread.id }) {
            threads.append(thread)
            let encoded = try JSONEncoder().encode(threads)
            userDefaults.set(encoded, forKey: threadsKey)
        }
    }
    
    func deleteThread(_ threadId: String) throws {
        var threads = try fetchThreads()
        threads.removeAll(where: { $0.id == threadId })
        let encoded = try JSONEncoder().encode(threads)
        userDefaults.set(encoded, forKey: threadsKey)
    }
    
    func fetchThreads() throws -> [AIThread] {
        guard let data = userDefaults.data(forKey: threadsKey) else { return [] }
        return try JSONDecoder().decode([AIThread].self, from: data)
    }
    
    func saveMessages(for threadId: String, messages: [Message]) throws {
        let key = "\(messagesKeyPrefix)\(threadId)"
        let encoded = try JSONEncoder().encode(messages)
        userDefaults.set(encoded, forKey: key)
    }
    
    func deleteMessages(for threadId: String) throws {
        let key = "\(messagesKeyPrefix)\(threadId)"
        userDefaults.removeObject(forKey: key)
    }
    
    func fetchMessages(for threadId: String) throws -> [Message] {
        let key = "\(messagesKeyPrefix)\(threadId)"
        guard let data = userDefaults.data(forKey: key) else { return [] }
        return try JSONDecoder().decode([Message].self, from: data)
    }
}
