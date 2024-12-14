//
//  OpenAIThreadManager.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

class OpenAIThreadManagerImpl: OpenAIThreadManager {
    private var threads: [String: ThreadContext] = [:]
    
    private let apiKey: String
    private let session: URLSessionProtocol
    
    /**
     Initializes the thread manager with an API key.
     - Parameter apiKey: The OpenAI API key.
    */
    init(apiKey: String, session: URLSessionProtocol = URLSession.shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func openThread() -> String {
        let threadId = UUID().uuidString
        threads[threadId] = ThreadContext(id: threadId, prompts: [])
        return threadId
    }

    func sendRequest(threadId: String, prompt: String, images: [Data], completion: @escaping @Sendable (Result<[String: Any], Error>) -> Void) {
        guard let threadContext = threads[threadId] else {
            completion(.failure(ThreadError.threadNotFound))
            return
        }

        threadContext.prompts.append(prompt)

        var request = URLRequest(url: URL(string: Constants.urlResolver(endpoint: .chat))!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let requestBody: [String: Any] = [
                "thread_id": threadId,
                "prompt": threadContext.prompts.joined(separator: "\n"),
                "images": images.map { $0.base64EncodedString() }
            ]

            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(ThreadError.invalidRequestBody))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ThreadError.invalidResponseStatus))
                return
            }

            guard let data = data, let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(.failure(ThreadError.invalidResponse))
                return
            }

            completion(.success(jsonResponse))
        }

        task.resume()
    }

    func closeThread(threadId: String) {
        threads.removeValue(forKey: threadId)
    }
}
