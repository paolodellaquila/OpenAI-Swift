//
//  OpenAIServiceTests.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//


import XCTest
@testable import OpenAI

final class OpenAIServiceTests: XCTestCase {
    var mockService: MockOpenAIService!
    
    override func setUp() {
        super.setUp()
        mockService = MockOpenAIService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - THREAD TESTS
    
    func testOpenThreadSuccess() async throws {
        let thread = try await mockService.openThread()
        XCTAssertEqual(thread.id, "mock-thread-id")
        XCTAssertEqual(thread.object, "thread")
    }
    
    func testFetchThreadsSuccess() async throws {
        let mockThreads = [
            AIThread(id: "thread-1", object: "thread", createdAt: 12345),
            AIThread(id: "thread-2", object: "thread", createdAt: 67890)
        ]
        mockService.mockThreads = mockThreads
        
        let threads = try await mockService.fetchThreads()
        XCTAssertEqual(threads.count, 2)
        XCTAssertEqual(threads[0].id, "thread-1")
        XCTAssertEqual(threads[1].id, "thread-2")
    }
    
    func testDeleteThreadSuccess() async throws {
        let success = try await mockService.deleteThread(threadId: "mock-thread-id")
        XCTAssertTrue(success)
    }
    
    func testDeleteThreadFailure() async throws {
        mockService.shouldThrowError = true
        do {
            _ = try await mockService.deleteThread(threadId: "mock-thread-id")
            XCTFail("Expected error but succeeded")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    // MARK: - MESSAGE TESTS
    
    func testFetchMessagesSuccess() async throws {
        let mockMessages = [
            Message(
                id: "msg-1",
                object: "thread.message",
                createdAt: 12345,
                assistantID: nil,
                threadID: "thread-1",
                runID: nil,
                role: "user",
                content: [],
                attachments: []
            ),
            Message(
                id: "msg-2",
                object: "thread.message",
                createdAt: 67890,
                assistantID: nil,
                threadID: "thread-1",
                runID: nil,
                role: "user",
                content: [],
                attachments: []
            )
        ]
        mockService.mockMessages = mockMessages
        
        let messages = try await mockService.fetchMessages(threadId: "thread-1")
        XCTAssertEqual(messages.count, 2)
        XCTAssertEqual(messages[0].id, "msg-1")
        XCTAssertEqual(messages[1].id, "msg-2")
    }
    
    func testCreateMessageSuccess() async throws {
        let message = try await mockService.createMessage(
            threadId: "thread-1",
            prompt: "Hello, OpenAI!",
            image: nil
        )
        XCTAssertEqual(message.id, "mock-message-id")
        XCTAssertEqual(message.threadID, "thread-1")
        XCTAssertEqual(message.content.first?.text?.text.value, "Hello, OpenAI!")
    }
    
    func testCreateMessageFailure() async throws {
        mockService.shouldThrowError = true
        do {
            _ = try await mockService.createMessage(threadId: "thread-1", prompt: "Fail", image: nil)
            XCTFail("Expected error but succeeded")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    // MARK: - FILE TESTS
    
    func testFetchFilesSuccess() async throws {
        let mockFiles = [
            File(id: "file-1", bytes: 1024, createdAt: 12345, filename: "file1.png"),
            File(id: "file-2", bytes: 2048, createdAt: 67890, filename: "file2.png")
        ]
        mockService.mockFiles = mockFiles
        
        let files = try await mockService.fetchFiles()
        XCTAssertEqual(files.count, 2)
        XCTAssertEqual(files[0].filename, "file1.png")
        XCTAssertEqual(files[1].filename, "file2.png")
    }
    
    func testFetchFileContentSuccess() async throws {
        let mockData = Data([0xFF, 0xD8, 0xFF]) // Mock binary data
        mockService.mockFileContent = mockData
        
        let data = try await mockService.fetchFileContent(fileId: "file-1")
        XCTAssertNotNil(data)
        XCTAssertEqual(data, mockData)
    }
    
    func testUploadFileSuccess() async throws {
        let fileParams = FileParameters(fileName: "upload.png", file: Data(), purpose: "assistants")
        let uploadedFile = try await mockService.uploadFile(params: fileParams)
        
        XCTAssertEqual(uploadedFile.id, "mock-file-id")
        XCTAssertEqual(uploadedFile.filename, "upload.png")
    }
    
    func testUploadFileFailure() async throws {
        mockService.shouldThrowError = true
        do {
            let fileParams = FileParameters(fileName: "upload.png", file: Data(), purpose: "assistants")
            _ = try await mockService.uploadFile(params: fileParams)
            XCTFail("Expected error but succeeded")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}

