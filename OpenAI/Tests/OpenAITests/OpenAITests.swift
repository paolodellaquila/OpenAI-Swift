import XCTest
@testable import OpenAI

class OpenAIServiceTests: XCTestCase {

    //MARK: Threads
    func testCreateThread() async throws {
        do {
            let mockThreadResponse = ThreadResponse(
                id: "mock-thread-id",
                object: "thread",
                createdAt: 1700000000,
                metadata: [:]
            )
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockThreadResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let api = OpenAIAPI.thread(.create)
            
            let finalURL = URL(string: api.base + api.path)!
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
    func testDeleteThreadSuccess() async throws {
        do {
            let mockThreadResponse = DeletionStatus(
                id: "mock-thread-id",
                object: "",
                deleted: true
            )
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockThreadResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let api = OpenAIAPI.thread(.delete(threadID: "mock-thread-id"))
            
            let finalURL = URL(string: api.base + api.path)!
            mockSession.response = HTTPURLResponse(
                url: finalURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            // initialize aiService with mock session and custom response
            let aiService = OpenAIServiceImpl(apiKey: "test-api-key", session: mockSession)
            
            // Open a new thread
            let status = try await aiService.deleteThread(threadId: "mock-thread-id")
            
            // Validate the thread
            XCTAssert(status)
            
        } catch {
            XCTFail("Expected success, but got failure")
        }
    }

    //MARK: Message
    func testCreateMessageSuccess() async throws {
        do {
            let mockMessageResponse = MessageResponse(
                id: "run-id",
                object: "",
                createdAt: 00000,
                threadID: "test-thread-success",
                status: "id-object",
                completedAt: 00000,
                role: "",
                content: [],
                assistantID: nil,
                runID: "",
                attachments: [],
                metadata: nil
            )
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockMessageResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let api = OpenAIAPI.message(.create(threadID: "id"))
            
            let finalURL = URL(string: api.base + api.path)!
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
            XCTAssert(message.threadID == "test-thread-success" && message.id == "run-id")
        } catch {
            XCTFail("Expected success, but got failure")
        }
    }
    func testListMessageSuccess() async throws {
        do {
            let mockMessageResponse = [MessageResponse(
                id: "run-id",
                object: "",
                createdAt: 00000,
                threadID: "test-thread-success",
                status: "id-object",
                completedAt: 00000,
                role: "",
                content: [],
                assistantID: nil,
                runID: "",
                attachments: [],
                metadata: nil
            )]
            
            // Encode the mock ThreadResponse to JSON
            let mockData = try? JSONEncoder().encode(mockMessageResponse)
            
            // Mock session data
            let mockSession = URLSessionMock()
            mockSession.data = mockData
            
            let api = OpenAIAPI.message(.create(threadID: "id"))
            
            let finalURL = URL(string: api.base + api.path)!
            mockSession.response = HTTPURLResponse(
                url: finalURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            // initialize aiService with mock session and custom response
            let aiService = OpenAIServiceImpl(apiKey: "test-api-key", session: mockSession)
            
            // Send a request
            let messages = try await aiService.listMessages(threadId: "test-thread-success")
            
            // Validate response
            XCTAssert(!messages.isEmpty)
        } catch {
            XCTFail("Expected success, but got failure")
        }
    }
}
