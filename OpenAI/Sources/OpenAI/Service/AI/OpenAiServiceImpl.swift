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

    
    /**
     Initializes the thread manager with an API key.
     - Parameter apiKey: The OpenAI API key.
     - Parameter baseURL: The OpenAI Api base url
     - Parameter session: URLSession shared client
     - Parameter organizationID: The OpenAI API project organization id.
    */
    init(
        apiKey: String,
        baseURL: String,
        session: URLSessionProtocol = URLSession.shared,
        organizationID: String? = nil
    ) {
        self.apiKey = .bearer(apiKey)
        APIConstants.overrideBaseURL = baseURL
        self.session = session
        self.organizationID = organizationID
    }

    func openThread() async throws -> Thread {
        let request = try APIConstants.thread.request(apiKey: apiKey, organizationID: nil, method: .post)
        return try await fetch(debugEnabled: true, type: ThreadResponse.self, with: request)
    }
    
    
    func closeThread(threadId: String) {
        threads.removeValue(forKey: threadId)
    }
    

    func createMessage(threadId: String, prompt: String, images: [Data], completion: @escaping @Sendable (Result<[String: Any], Error>) -> Void) {
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
                "model": "gpt-4o",
                "messages": [
                    [
                        "role": "user",
                        "content": [
                            ["type": "text", "text": prompt],
                            ["type": "image_url", "image_url": ["url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"]]
                        ]
                    ]
                ],
                "max_tokens": 300
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
}
