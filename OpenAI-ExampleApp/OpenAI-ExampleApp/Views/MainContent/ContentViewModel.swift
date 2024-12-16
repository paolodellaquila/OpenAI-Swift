//
//  OpenAIViewModel.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation
import OpenAI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var thread: AIThread?
    @Published var prompt: String = ""
    
    @Published var responses: [String] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let openAI = OpenAI()
    
    func openThread() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let newThread = try await openAI.openThread()
                self.thread = newThread
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
    
    func createMessage() {
        guard let thread = thread, !prompt.isEmpty else {
            errorMessage = "Thread or prompt is missing"
            showError = true
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do{
                _ = try await self.openAI.createMessage(threadId: thread.id, prompt: self.prompt, images: [])
                //TODO
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }
        }
        
    }
}
