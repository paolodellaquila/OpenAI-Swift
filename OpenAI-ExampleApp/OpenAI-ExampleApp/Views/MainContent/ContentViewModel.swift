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
    @Published var threads: [AIThread] = [] // List of threads
    @Published var selectedThread: AIThread? // Selected thread
    @Published var messages: [Message] = [] // Messages of the selected thread
    @Published var prompt: String = "" // Current user prompt
    @Published var selectedImage: NSImage? = nil // Selected image preview
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoadingThreads: Bool = false // Loading state for threads
    @Published var isLoadingMessages: Bool = false // Loading state for messages
    
    private let openAI = OpenAI()

}


//-- Thread
extension ContentViewModel {
    
    func loadThreads() {
        Task {
            do {
                isLoadingThreads = true
                threads = try await openAI.service.fetchThreads()
            } catch {
                errorMessage = "Failed to load threads: \(error.localizedDescription)"
                showError = true
            }
            isLoadingThreads = false
        }
    }
    
    func openThread() {
        Task {
            do {
                isLoadingThreads = true
                let newThread = try await openAI.service.openThread()
                threads.append(newThread)
            } catch {
                errorMessage = "Failed to create thread: \(error.localizedDescription)"
                showError = true
            }
            
            isLoadingThreads = false
        }
    }


}


//-- Message
extension ContentViewModel {
    
    // Send a message
    func createMessage() {
        guard let thread = selectedThread, !prompt.isEmpty else {
            errorMessage = "Thread or prompt is missing"
            showError = true
            return
        }
        
        Task {
            do {
                isLoadingMessages = true
                let newMessage = try await openAI.service.createMessage(threadId: thread.id, prompt: prompt, images: [])
                messages.append(newMessage)
                prompt = "" // Clear prompt after sending
            } catch {
                errorMessage = "Failed to send message: \(error.localizedDescription)"
                showError = true
            }
            isLoadingMessages = false
        }
    }
    
    func loadMessages(_ thread: AIThread) {
        Task {
            do {
                selectedThread = thread
                isLoadingMessages = true
                messages = try await openAI.service.fetchMessages(threadId: thread.id)
            } catch {
                errorMessage = "Failed to load messages: \(error.localizedDescription)"
                showError = true
            }
            isLoadingMessages = false
        }
    }
}

// -- Image
extension ContentViewModel {
    
    func attachImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            
            Task {
                do {
                    let imageData = try Data(contentsOf: url)
                    if let image = NSImage(data: imageData) {
                        selectedImage = image
                    }
                    
                    isLoadingMessages = true
                    try await openAI.service.uploadFile(params: FileParameters(fileName: panel.representedFilename, file: imageData, purpose: "assistants"))
                    isLoadingMessages = false
                } catch {
                    self.errorMessage = "Failed to load image: \(error.localizedDescription)"
                    self.showError = true
                }
            }
        }
    }
    
    func removeImage() {
        selectedImage = nil
    }

}
