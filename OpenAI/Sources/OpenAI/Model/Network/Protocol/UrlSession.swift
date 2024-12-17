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
public protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func bytes(for request: URLRequest) async throws -> (URLSession.AsyncBytes, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    public func bytes(for request: URLRequest) async throws -> (URLSession.AsyncBytes, URLResponse) {
        // Call the native URLSession.bytes(for:) method
        let response = try await self.bytes(for: request)
        return response
    }
}
