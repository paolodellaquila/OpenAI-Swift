//
//  OpenAIViewModel.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation
import OpenAI

class ContentViewModel: ObservableObject {
    @Published var thread: Thread?
    @Published var prompt: String = ""
    @Published var responses: [String] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let openAI = OpenAI()
    
    func openThread() {
        thread = await openAI.openThread()
    }
    
    func sendRequest() {
        guard let threadId = threadId, !prompt.isEmpty else {
            errorMessage = "Thread ID or prompt is missing"
            showError = true
            return
        }
        
        openAI.sendRequest(threadId: threadId, prompt: prompt, images: []) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let message = response["response"] as? String {
                        self.responses.append(message)
                    } else {
                        self.responses.append("Invalid response format")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
