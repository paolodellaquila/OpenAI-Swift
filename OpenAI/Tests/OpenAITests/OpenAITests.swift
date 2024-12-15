import XCTest
@testable import OpenAI

class OpenAIServiceTests: XCTestCase {

    func testCreateThread() async throws {
        do {
            let mockThreadResponse = ThreadResponse(
                id: "mock-thread-id",
                object: "thread",
                createdAt: 1700000000,
                deleted: nil
            )
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockThreadResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let finalURL = URL(string: APIConstants.thread.base + APIConstants.thread.path)!
            mockSession.response = HTTPURLResponse(
                url: finalURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            // initialize aiService with mock session and custom response
            let aiService = OpenAIServiceImpl(apiKey: "test-api-key", session: mockSession)
            
            // Open a new thread
            let thread = try await aiService.openThread()
            
            // Validate the thread
            XCTAssert(thread.id == "mock-thread-id")
            
        } catch {
            XCTFail("Expected success, but got failure")
        }
    }

    func testSendRequestSuccess() async throws {
        do {
            let mockMessageResponse = MessageResponse(
                id: "id",
                object: "id-object",
                createdAt: 00000,
                assistantID: nil,
                threadID: "test-thread-success",
                runID: nil,
                role: "",
                content: [],
                attachments: []
            )
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockMessageResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let finalURL = URL(string: APIConstants.message(threadId: "test-thread-success").base + APIConstants.message(threadId: "test-thread-success").path)!
            mockSession.response = HTTPURLResponse(
                url: finalURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            // initialize aiService with mock session and custom response
            let aiService = OpenAIServiceImpl(apiKey: "test-api-key", session: mockSession)
            
            // Send a request
            let message = try await aiService.createMessage(threadId: "test-thread-success", prompt: "Hello", images: [])
            
            // Validate response
            XCTAssert(message.threadID == "test-thread-success" && message.id == "id")
        } catch {
            XCTFail("Expected success, but got failure")
        }
    }
}
