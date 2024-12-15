//
//  OpenAIThreadManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

class OpenAIServiceImpl: OpenAIService {
    
    private let apiKey: Authorization
    private let session: URLSessionProtocol
    private let organizationID: String?
    
    private let networkService: NetworkService

    
    /**
     Initializes the thread manager with an API key.
     - Parameter apiKey: The OpenAI API key.
     - Parameter session: URLSession shared client
     - Parameter baseURL: The OpenAI Api base url
     - Parameter organizationID: The OpenAI API project organization id.
    */
    init(
        apiKey: String,
        session: URLSessionProtocol = URLSession.shared,
        baseURL: String? = nil,
        organizationID: String? = nil
    ) {
        self.apiKey = .bearer(apiKey)
        APIConstants.overrideBaseURL = baseURL
        self.session = session
        self.organizationID = organizationID
        self.networkService = NetworkServiceImpl(session: session)
    }

    //MARK: -- Threads
    public func openThread() async throws -> AIThread {
        let request = try APIConstants.thread.request(apiKey: apiKey, organizationID: nil, method: .post)
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        return AIThread.fromThreadResponse(response)
    }
    public func deleteThread(threadId: String) async throws -> Bool {
        let request = try APIConstants.thread.request(apiKey: apiKey, organizationID: nil, method: .delete, queryItems: [URLQueryItem(name: "thread_id", value: threadId)])
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        return response.deleted ?? false
    }
    

    //MARK: -- Messages
    public func listMessages(threadId: String) async throws -> [AIMessage] {
        let request = try APIConstants.message(threadId: threadId).request(apiKey: apiKey, organizationID: nil, method: .get)
        let response = try await self.networkService.fetch(debugEnabled: true, type: [MessageResponse].self, with: request)
        return AIMessage.fromMessageResponse(response)
    }
    public func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> AIMessage {
        let request = try APIConstants.message(threadId: threadId).request(apiKey: apiKey, organizationID: nil, method: .post)
        let response = try await self.networkService.fetch(debugEnabled: true, type: MessageResponse.self, with: request)
        return AIMessage.fromMessageResponse(response)
    }
}
