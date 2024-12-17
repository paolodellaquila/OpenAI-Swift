//
//  OpenAIThreadManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

class OpenAIServiceImpl: OpenAIService {
    private let apiKey: Authorization
    private let assistantID: String
    private let session: URLSession
    private let organizationID: String?

    private let networkService: NetworkService
    private let cacheService: CacheService

    
    /**
     Initializes the thread manager with an API key.
     - Parameter apiKey: The OpenAI API key.
     - Parameter session: URLSession shared client
     - Parameter baseURL: The OpenAI Api base url
     - Parameter organizationID: The OpenAI API project organization id.
    */
    init(
        apiKey: String,
        assistantID: String,
        session: URLSession = URLSession.shared,
        baseURL: String? = nil,
        version: String? = nil,
        organizationID: String? = nil
    ) {
        self.apiKey = .bearer(apiKey)
        OpenAIAPI.overrideBaseURL = baseURL
        OpenAIAPI.overrideVersion = version
        self.session = session
        self.organizationID = organizationID
        self.assistantID = assistantID
        self.networkService = NetworkServiceImpl(session: session)
        self.cacheService = CacheServiceImpl()
    }

    //MARK: -- Threads [BETA]
    public func openThread() async throws -> AIThread {
        let request = try OpenAIAPI.thread(.create).request(apiKey: apiKey, organizationID: organizationID, method: .post, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
        let thread = AIThread.fromThreadResponse(response)
        try self.cacheService.saveThread(thread)
        
        return thread
    }
    
    public func fetchThreads() async throws -> [AIThread] {
        return try self.cacheService.fetchThreads()
    }
    
    public func deleteThread(threadId: String) async throws -> Bool {
        let request = try OpenAIAPI.thread(.delete(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .delete, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        let response = try await self.networkService.fetch(debugEnabled: true, type: DeletionStatus.self, with: request)
        let result = response.deleted
        
        if result {
                try self.cacheService.deleteThread(threadId)
        }
        
        return result
    }
    

    //MARK: -- Messages [BETA]
    func fetchMessages(threadId: String) async throws -> [Message] {
        
       let config = FetchMessagesConfig()
           
       var queryItems: [URLQueryItem] = []
       if let limit = config.limit {
           queryItems.append(.init(name: "limit", value: "\(limit)"))
       }
       if let order = config.order {
           queryItems.append(.init(name: "order", value: order))
       }
       if let after = config.after {
           queryItems.append(.init(name: "after", value: after))
       }
       if let before = config.before {
           queryItems.append(.init(name: "before", value: before))
       }
       if let runID = config.runID {
           queryItems.append(.init(name: "run_id", value: runID))
       }
       
       let request = try OpenAIAPI.message(.list(threadID: threadId)).request(apiKey: self.apiKey, organizationID: self.organizationID, method: .get, queryItems: queryItems, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
       let response = try? await self.networkService.fetch(debugEnabled: true, type: MessageListResponse.self, with: request)

       if let response {
           let messages = Message.fromMessageResponse(response.data)
           try self.cacheService.saveMessages(for: threadId, messages: messages)
           return messages
       }
        
        return []
    }
    
    public func createMessage(threadId: String, prompt: String, image: Data?) async throws -> Message {
        
        var uploadedFile: File?
        
        // Step 1: Upload the file if an image is provided
        if let image {
            uploadedFile = try await uploadFile(params: FileParameters(fileName: UUID().uuidString + ".jpg", file: image))
        }
        
        // Step 2: Build the content array
        var content: [MessageContentRequest] = []
        
        if let uploadedFile {
            content.append(.imageContent(fileId: uploadedFile.id))
        }
        
        // Add the text content
        content.append(.textContent(prompt))
        
        // Step 3: Construct the request body
        let messageRequest = MessageRequest(
            role: "user",
            content: content
        )
        
        // Step 4: Build the request
        let request = try OpenAIAPI.message(.create(threadID: threadId)).request(apiKey: apiKey, organizationID: organizationID, method: .post, params: messageRequest, betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        
        let response = try await self.networkService.fetch(debugEnabled: true, type: MessageResponse.self, with: request)
        let message = Message.fromMessageResponse(response)
        
        try self.cacheService.saveMessages(for: threadId, messages: [message])
        return message
    }
    
    
    // MARK: -- Run [BETA]
    func createRun(threadId: String) async throws -> AsyncThrowingStream<AssistantStreamEvent, Error> {
        let request = try OpenAIAPI.run(.create(threadID: threadId))
            .request(apiKey: apiKey, organizationID: organizationID, method: .post, params: RunRequest(assistantId: self.assistantID), betaHeaderField: OpenAIAPI.assistanceBetaHeader)
        
        return try await self.networkService.fetchAssistantStreamEvents(with: request, debugEnabled: true)
        
    }
    
    func fetchRuns(
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
    
    //MARK: -- File [BETA]
    func fetchFiles() async throws -> [File]
    {
       let request = try OpenAIAPI.file(.list).request(apiKey: apiKey, organizationID: organizationID, method: .get)
       let response = try await self.networkService.fetch(debugEnabled: true, type: [FileResponse].self, with: request)
       return File.fromFileResponse(response)
    }
    
    func fetchFileContent(fileId: String) async throws -> Data?
    {
       let request = try OpenAIAPI.file(.retrieveFileContent(fileID: fileId)).request(apiKey: apiKey, organizationID: organizationID, method: .get)
       let response = try await self.networkService.fetchContentsOfFile(request: request)
       return response
    }
    
    
    // MARK: -- Upload [BETA]
    func uploadFile(params: FileParameters) async throws -> File
    {
       let request = try OpenAIAPI.file(.upload).multiPartRequest(apiKey: apiKey, organizationID: organizationID, method: .post, params: params)
       let response = try await self.networkService.fetch(debugEnabled: true, type: FileResponse.self, with: request)
       return File.fromFileResponse(response)
    }
}
