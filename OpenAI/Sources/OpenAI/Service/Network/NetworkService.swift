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
    var session: URLSessionProtocol { get }
    
    
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
    
}
