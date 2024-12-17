//
//  UrlSession.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

/**
 Protocol to abstract URLSession for dependency injection and mocking.
 */
/*public protocol URLSessionProtocol {
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func bytes(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URLSession.AsyncBytes, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await self.data(for: request)
    }

    public func bytes(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URLSession.AsyncBytes, URLResponse) {
        // Use the specified delegate here
        let (stream, response) = try await self.bytes(for: request, delegate: delegate)
        return (stream, response)
    }
}*/
