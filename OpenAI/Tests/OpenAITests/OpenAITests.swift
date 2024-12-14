//
//  OpenAI.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import XCTest
@testable import OpenAI

public class OpenAIThreadManagerTests: XCTestCase {

    func testOpenThread() {
        let manager = OpenAIThreadManager(apiKey: "test-api-key")
        let threadId = manager.openThread()

        XCTAssertFalse(threadId.isEmpty, "Thread ID should not be empty")
    }

    @MainActor func testSendRequestWithInvalidThread() {
        let manager = OpenAIThreadManager(apiKey: "test-api-key")
        let expectation = self.expectation(description: "Completion should be called")

        manager.sendRequest(threadId: "invalid-thread", prompt: "Test", images: []) { result in
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
        let manager = OpenAIThreadManager(apiKey: "test-api-key")
        let threadId = manager.openThread()
        let expectation = self.expectation(description: "Completion should be called")

        // Mock data and response
        let sessionMock = URLSessionMock()
        sessionMock.data = try? JSONSerialization.data(withJSONObject: ["response": "Success"])
        sessionMock.response = HTTPURLResponse(url: URL(string: "https://api.openai.com/v1/chat/completions")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        manager.sendRequest(threadId: threadId, prompt: "Hello", images: []) { result in
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


