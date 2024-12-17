//
//  MockOpenAIService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//

import Foundation
@testable import OpenAI

class MockOpenAIService: OpenAIService {
    // MARK: - Mock Data
    var mockThreads: [AIThread] = []
    var mockMessages: [Message] = []
    var mockFileContent: Data?
    var mockFiles: [File] = []
    var mockRuns: [Run] = []
    var mockUploadedFile: File?
    var mockStreamEvents: [AssistantStreamEvent] = []
    var shouldThrowError: Bool = false
    
    // MARK: - OpenAIService Methods
    
    func openThread() async throws -> AIThread {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to open thread") }
        return AIThread(id: "mock-thread-id", object: "thread", createdAt: Int(Date().timeIntervalSince1970))
    }
    
    func fetchThreads() async throws -> [AIThread] {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to fetch threads") }
        return mockThreads
    }
    
    func deleteThread(threadId: String) async throws -> Bool {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to delete thread") }
        return true
    }
    
    func fetchMessages(threadId: String) async throws -> [Message] {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to fetch messages") }
        return mockMessages
    }
    
    func createMessage(threadId: String, prompt: String, image: Data?) async throws -> Message {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to create message") }
        return Message(
            id: "mock-message-id",
            object: "thread.message",
            createdAt: Int(Date().timeIntervalSince1970),
            assistantID: nil,
            threadID: threadId,
            runID: nil,
            role: "user",
            content: [MessageContent(text: Text(type: "text", text: Text.TextContent(value: prompt)), imageFile: nil, type: .text)],
            attachments: []
        )
    }
    
    func createRun(threadId: String) async throws -> AsyncThrowingStream<AssistantStreamEvent, Error> {
        if shouldThrowError {
            throw APIError.requestFailed(description: "Failed to create run")
        }

        return AsyncThrowingStream { continuation in
            continuation.finish()

            // Handle task cancellation
            continuation.onTermination = { @Sendable _ in
                continuation.finish(throwing: CancellationError())
            }
        }
    }

    
    func fetchRuns(threadId: String, limit: Int?, order: String?, after: String?, before: String?) async throws -> [Run] {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to fetch runs") }
        return mockRuns
    }
    
    func fetchFiles() async throws -> [File] {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to fetch files") }
        return mockFiles
    }
    
    func fetchFileContent(fileId: String) async throws -> Data? {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to fetch file content") }
        return mockFileContent
    }
    
    func uploadFile(params: FileParameters) async throws -> File {
        if shouldThrowError { throw APIError.requestFailed(description: "Failed to upload file") }
        return mockUploadedFile ?? File(id: "mock-file-id", bytes: 1024, createdAt: Int(Date().timeIntervalSince1970), filename: params.fileName ?? "")
    }
}
