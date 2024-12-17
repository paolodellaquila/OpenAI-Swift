//
//  NetworkService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation

class NetworkServiceImpl: NetworkService {
    
    let session: URLSessionProtocol
    let decoder: JSONDecoder
    
    init(session: URLSessionProtocol, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func fetch<T: Decodable>(
        debugEnabled: Bool,
        type: T.Type,
        with request: URLRequest
    ) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid response: Unable to get a valid HTTPURLResponse")
        }
        
        if debugEnabled {
            if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                print("Request Body: \(bodyString)")
            }
            print("Request URL: \(request.url?.absoluteString ?? "No URL")")
            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
            NetworkMisc.printHTTPURLResponse(httpResponse)
        }
        
        // Handle non-successful status codes
        guard httpResponse.statusCode == 200 else {
            var errorMessage = "Status code \(httpResponse.statusCode)"
            
            // Try to decode the error response
            do {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("API Error JSON: \(jsonString)")
                }
                
                let errorResponse = try decoder.decode(OpenAIErrorResponse.self, from: data)
                errorMessage += " \(errorResponse.error.message ?? "NO ERROR MESSAGE PROVIDED")"
            } catch {
                // If decoding fails, print the raw response body
                let rawError = String(data: data, encoding: .utf8) ?? "Unable to parse error response"
                print("Raw API Error: \(rawError)")
                errorMessage += " | Raw response: \(rawError)"
            }
            
            throw APIError.responseUnsuccessful(description: errorMessage, statusCode: httpResponse.statusCode)
        }
        
        #if DEBUG
        if debugEnabled {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("DEBUG JSON FETCH API = \(prettyString)")
            } else {
                print("DEBUG JSON FETCH API = Unable to format response JSON")
            }
        }
        #endif
        
        // Decode the successful response
        do {
            return try decoder.decode(type, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
            let codingPath = "CodingPath: \(context.codingPath)"
            let debugMessage = debug + " | " + codingPath
            print("Decoding Error: \(debugMessage)")
            throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
        } catch {
            print("Decoding Error: \(error.localizedDescription)")
            throw APIError.jsonDecodingFailure(description: error.localizedDescription)
        }
    }

    
}
