//
//  NetworkService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation

public protocol NetworkService {
    
    /// `URLSession` responsible for executing all network requests.
    ///
    /// This session is configured according to the needs of OpenAI's API,
    /// and it's used for tasks like sending and receiving data.
    var session: URLSession { get }
    
    
    /// `JSONDecoder` instance used for decoding JSON responses.
    ///
    /// This decoder is used to parse the JSON responses returned by the API
    /// into model objects that conform to the `Decodable` protocol.
    var decoder: JSONDecoder { get }
    
    /// Asynchronously fetches a decodable data type from OpenAI's API.
    ///
    /// - Parameters:
    ///   - debugEnabled: If true the service will print events on DEBUG builds.
    ///   - type: The `Decodable` type that the response should be decoded to.
    ///   - request: The `URLRequest` describing the API request.
    /// - Throws: An error if the request fails or if decoding fails.
    /// - Returns: A value of the specified decodable type.
    func fetch<T: Decodable>(
        debugEnabled: Bool,
        type: T.Type,
        with request: URLRequest) async throws -> T
    
    
    /// Asynchronously fetches the contents of a file that has been uploaded to OpenAI's service.
    ///
    /// This method is used exclusively for retrieving the content of uploaded files.
    ///
    /// - Parameter request: The `URLRequest` describing the API request to fetch the file.
    /// - Throws: An error if the request fails.
    /// - Returns: A dictionary array representing the file contents.
    func fetchContentsOfFile(
       request: URLRequest)
       async throws -> Data
    
    
    
    /// Asynchronously fetches a stream of decodable data types from OpenAI's API for chat completions.
    ///
    /// This method is primarily used for streaming chat completions.
    ///
    /// - Parameters:
    ///   - debugEnabled: If true the service will print events on DEBUG builds.
    ///   - type: The `Decodable` type that each streamed response should be decoded to.
    ///   - request: The `URLRequest` describing the API request.
    /// - Throws: An error if the request fails or if decoding fails.
    /// - Returns: An asynchronous throwing stream of the specified decodable type.
    func fetchStream<T: Decodable>(
       debugEnabled: Bool,
       type: T.Type,
       with request: URLRequest)
       async throws -> AsyncThrowingStream<T, Error>
    
    
    func fetchAssistantStreamEvents(
       with request: URLRequest,
       debugEnabled: Bool)
       async throws -> AsyncThrowingStream<AssistantStreamEvent, Error>
    
}
