//
//  OpenAIViewModel.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation
import OpenAI

class ContentViewModel: ObservableObject {
    @Published var thread: AIThread?
    @Published var prompt: String = ""
    
    @Published var responses: [String] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let openAI = OpenAI()
    
    func openThread() {
        Task.detached { [weak self] in
            self?.thread = try? await self?.openAI.openThread()
        }
    }
    
    func createMessage() {
        guard let thread = thread, !prompt.isEmpty else {
            errorMessage = "Thread or prompt is missing"
            showError = true
            return
        }
        
        Task.detached { [weak self] in
            do{
                _ = try await self?.openAI.createMessage(threadId: thread.id, prompt: self?.prompt ?? "", images: [])
                //TODO
            } catch {
                self?.errorMessage = error.localizedDescription
                self?.showError = true
                return
            }
        }
        
    }
}
