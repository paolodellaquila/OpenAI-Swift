//
//  NetworkService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation


/// Asynchronously fetches a decodable data type from OpenAI's API.
///
/// - Parameters:
///   - debugEnabled: If true the service will print events on DEBUG builds.
///   - type: The `Decodable` type that the response should be decoded to.
///   - request: The `URLRequest` describing the API request.
/// - Throws: An error if the request fails or if decoding fails.
/// - Returns: A value of the specified decodable type.

class NetworkService {
    
    let session: URLSession
    let decoder: JSONDecoder = JSONDecoder()
    
    init(session: URLSession) {
        self.session = session
    }
    
    public func fetch<T: Decodable>(
        debugEnabled: Bool,
        type: T.Type,
        with request: URLRequest)
    async throws -> T
    {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
        }
        if debugEnabled {
            printHTTPURLResponse(httpResponse)
        }
        guard httpResponse.statusCode == 200 else {
            var errorMessage = "status code \(httpResponse.statusCode)"
            do {
                let error = try decoder.decode(OpenAIErrorResponse.self, from: data)
                errorMessage += " \(error.error.message ?? "NO ERROR MESSAGE PROVIDED")"
            } catch {
                // If decoding fails, proceed with a general error message
                errorMessage = "status code \(httpResponse.statusCode)"
            }
            throw APIError.responseUnsuccessful(description: errorMessage,
                                                statusCode: httpResponse.statusCode)
        }
#if DEBUG
        if debugEnabled {
            print("DEBUG JSON FETCH API = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
        }
#endif
        do {
            return try decoder.decode(type, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
            let codingPath = "codingPath: \(context.codingPath)"
            let debugMessage = debug + codingPath
#if DEBUG
            if debugEnabled {
                print(debugMessage)
            }
#endif
            throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
        } catch {
#if DEBUG
            if debugEnabled {
                print("\(error)")
            }
#endif
            throw APIError.jsonDecodingFailure(description: error.localizedDescription)
        }
    }
    
}
