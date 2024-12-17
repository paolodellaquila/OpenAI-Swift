//
//  OpenAI.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation

/**
 Main class for interacting with OpenAI services. This class acts as a high-level interface, exposing useful methods for managing threads and sending requests.
 */
public class OpenAI {
    public let service: OpenAIService

    /**
     Initializes the OpenAI client. It retrieves the API key from environment variables.

     - Throws: A fatal error if the API key is not set in the environment variables.
    */
    public init() {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], let assistantId = ProcessInfo.processInfo.environment["OPENAI_ASSISTANT_ID"] else {
            fatalError("API Key or Assistant ID not found. Please set 'OPENAI_API_KEY' and 'OPENAI_ASSISTANT_ID' in your environment variables.")
        }
        self.service = OpenAIServiceImpl(apiKey: apiKey, assistantID: assistantId, organizationID: ProcessInfo.processInfo.environment["OPENAI_ORGANIZATION_ID"])
    }


}







