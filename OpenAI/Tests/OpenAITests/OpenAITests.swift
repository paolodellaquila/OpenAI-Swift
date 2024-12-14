//
//  OpenAI.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import XCTest
@testable import OpenAI

class OpenAIThreadManagerTests: XCTestCase {
    var mockManager: OpenAIThreadManager?
    
    override func setUp() {
        mockManager = OpenAIThreadManagerImpl(apiKey: "test-api-key")
    }

    func testOpenThread() {
        let threadId = mockManager?.openThread()
        
        guard let threadId = threadId else {
            XCTFail("Thread ID should not be nil")
            return
        }

        XCTAssertFalse(threadId.isEmpty, "Thread ID should not be empty")
    }

    @MainActor func testSendRequestWithInvalidThread() {
        let expectation = self.expectation(description: "Completion should be called")

        mockManager?.sendRequest(threadId: "invalid-thread", prompt: "Test", images: []) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? ThreadError, .threadNotFound, "Error should be threadNotFound")
            } else {
                XCTFail("Expected failure, got success")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }

    @MainActor func testSendRequestSuccess() {
        // Setup Mock Session
        let mockSession = URLSessionMock()
        mockSession.data = try? JSONSerialization.data(withJSONObject: ["response": "Success"])
        mockSession.response = HTTPURLResponse(
            url: URL(string: Constants.urlResolver(endpoint: .chat))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let customMockManager = OpenAIThreadManagerImpl(apiKey: "test-api-key", session: mockSession)
        
        let threadId = customMockManager.openThread()

        let expectation = self.expectation(description: "Completion should be called")

        customMockManager.sendRequest(threadId: threadId, prompt: "Hello", images: []) { result in
            if case .success(let response) = result {
                XCTAssertEqual(response["response"] as? String, "Success", "Response should be 'Success'")
            } else {
                XCTFail("Expected success, got failure")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
    }
}


