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
    func openThread() async throws -> Thread {
        let request = try APIConstants.thread.request(apiKey: apiKey, organizationID: nil, method: .post)
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        return Thread.fromThreadResponse(response)
    }
    func deleteThread(threadId: String) async throws -> Bool {
        let request = try APIConstants.thread.request(apiKey: apiKey, organizationID: nil, method: .delete, queryItems: [URLQueryItem(name: "thread_id", value: threadId)])
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        return response.deleted ?? false
    }
    

    //MARK: -- Messages
    func listMessages(threadId: String) async throws -> [Message] {
        let request = try APIConstants.message(threadId: threadId).request(apiKey: apiKey, organizationID: nil, method: .get)
        let response = try await self.networkService.fetch(debugEnabled: true, type: [MessageResponse].self, with: request)
        return Message.fromMessageResponse(response)
    }
    func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> Message {
        let request = try APIConstants.message(threadId: threadId).request(apiKey: apiKey, organizationID: nil, method: .post)
        let response = try await self.networkService.fetch(debugEnabled: true, type: MessageResponse.self, with: request)
        return Message.fromMessageResponse(response)
    }
}
