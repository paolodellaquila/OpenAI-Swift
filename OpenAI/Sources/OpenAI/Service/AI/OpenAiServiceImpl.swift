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
        version: String? = nil,
        organizationID: String? = nil
    ) {
        self.apiKey = .bearer(apiKey)
        OpenAIAPI.overrideBaseURL = baseURL
        OpenAIAPI.overrideVersion = version
        self.session = session
        self.organizationID = organizationID
        self.networkService = NetworkServiceImpl(session: session)
    }

    //MARK: -- Threads [BETA]
    public func openThread() async throws -> AIThread {
        let request = try OpenAIAPI.thread(.create).request(apiKey: apiKey, organizationID: organizationID, method: .post, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        return AIThread.fromThreadResponse(response)
    }
    public func deleteThread(threadId: String) async throws -> Bool {
        let request = try OpenAIAPI.thread(.delete(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .delete, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: DeletionStatus.self, with: request)
        return response.deleted
    }
    

    //MARK: -- Messages [BETA]
    func listMessages(
       threadId: String,
       limit: Int? = nil,
       order: String? = nil,
       after: String? = nil,
       before: String? = nil,
       runID: String? = nil)
       async throws -> [Message] {
           
       var queryItems: [URLQueryItem] = []
       if let limit {
          queryItems.append(.init(name: "limit", value: "\(limit)"))
       }
       if let order {
          queryItems.append(.init(name: "order", value: order))
       }
       if let after {
          queryItems.append(.init(name: "after", value: after))
       }
       if let before {
          queryItems.append(.init(name: "before", value: before))
       }
       if let runID {
          queryItems.append(.init(name: "run_id", value: runID))
       }
        
       let request = try OpenAIAPI.message(.list(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .get, queryItems: queryItems, betaHeaderField: "assistants=v2")
       let response = try await self.networkService.fetch(debugEnabled: true, type: [MessageResponse].self, with: request)
       return Message.fromMessageResponse(response)
    }
    
    public func createMessage(threadId: String, prompt: String, images: [Data]) async throws -> Message {
        let request = try OpenAIAPI.message(.create(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .post, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: MessageResponse.self, with: request)
        return Message.fromMessageResponse(response)
    }
    
    
    // MARK: -- Run [BETA]
    func createRun(threadId: String) async throws -> Run {
        let request = try OpenAIAPI.run(.create(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .post, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: RunResponse.self, with: request)
        return Run.fromRunResponse(response)
    }
    
    func listRuns(
       threadId: String,
       limit: Int? = nil,
       order: String? = nil,
       after: String? = nil,
       before: String? = nil)
       async throws -> [Run]
    {
       var queryItems: [URLQueryItem] = []
       if let limit {
          queryItems.append(.init(name: "limit", value: "\(limit)"))
       }
       if let order {
          queryItems.append(.init(name: "order", value: order))
       }
       if let after {
          queryItems.append(.init(name: "after", value: after))
       }
       if let before {
          queryItems.append(.init(name: "before", value: before))
       }
        
        let request = try OpenAIAPI.run(.list(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .get, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: [RunResponse].self, with: request)
        return Run.fromRunResponse(response)
    }
    
    // MARK: -- Files [BETA]
    func listFiles() async throws -> [File]
    {
       let request = try OpenAIAPI.file(.list).request(apiKey: apiKey, organizationID: organizationID, method: .get)
       let response = try await self.networkService.fetch(debugEnabled: true, type: [FileResponse].self, with: request)
       return File.fromFileResponse(response)
    }
    
    func uploadFile(params: FileParameters) async throws -> File
    {
       let request = try OpenAIAPI.file(.upload).multiPartRequest(apiKey: apiKey, organizationID: organizationID, method: .post, params: params)
       let response = try await self.networkService.fetch(debugEnabled: true, type: FileResponse.self, with: request)
       return File.fromFileResponse(response)
    }
}
