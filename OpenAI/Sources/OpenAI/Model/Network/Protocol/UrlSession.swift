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
    var delegate: URLSessionDelegate? { get }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func bytes(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URLSession.AsyncBytes, URLResponse)
}

extension URLSession: URLSessionProtocol {
    
    public var delegate: URLSessionDelegate? {
        return self.delegate
    }
    
    public func bytes(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (URLSession.AsyncBytes, URLResponse) {
        let response = try await self.bytes(for: request, delegate: delegate)
        return response
    }
}
