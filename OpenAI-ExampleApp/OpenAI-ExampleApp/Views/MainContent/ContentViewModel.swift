//
//  OpenAIViewModel.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import Foundation
import OpenAI
import AppKit

@MainActor
class ContentViewModel: ObservableObject {
    @Published var thread: AIThread?
    @Published var prompt: String = ""
    
    @Published var responses: [String] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let openAI = OpenAI()
    
}


//-- Thread
///manage threads
extension ContentViewModel {
    func openThread() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let newThread = try await openAI.service.openThread()
                self.thread = newThread
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
}

//-- Message
///manaage messages
extension ContentViewModel {
    func createMessage() {
        guard let thread = thread, !prompt.isEmpty else {
            errorMessage = "Thread or prompt is missing"
            showError = true
            return
        }
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do{
                _ = try await self.openAI.service.createMessage(threadId: thread.id, prompt: self.prompt, images: [])
                //TODO
            } catch {
                self.errorMessage = error.localizedDescription
                self.showError = true
                return
            }
        }
        
    }
}

//-- Image
///manage images
extension ContentViewModel {
    func attachImage() {
        // macOS-specific image picker
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let imageData = try Data(contentsOf: url)
                
            } catch {
                self.errorMessage = "Failed to load image: \(error.localizedDescription)"
                self.showError = true
            }
        }
    }
}


