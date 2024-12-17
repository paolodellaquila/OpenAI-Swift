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
    @Published var imageCache: [String: NSImage] = [:] // Cache for images
    @Published var prompt: String = "" // Current user prompt
    @Published var selectedImage: Data? = nil // Selected image preview
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoadingThreads: Bool = false // Loading state for threads
    @Published var isLoadingMessages: Bool = false // Loading state for messages
    
    private let openAI = OpenAI()
    
    
    // Retrieve an image and cache it
    func loadImage(for fileId: String) async -> NSImage? {
        if let cachedImage = imageCache[fileId] {
            return cachedImage // Return cached image if available
        }
        
        do {
            let fileData = try await openAI.service.fetchFileContent(fileId: fileId)
            guard let fileData else { return nil }
            
            if let image = NSImage(data: fileData) {
                imageCache[fileId] = image // Cache the image
                return image
            }
        } catch {
            print("Failed to load image for file ID \(fileId): \(error.localizedDescription)")
        }
        
        return nil // Return nil if failed
    }

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
                let newMessage = try await openAI.service.createMessage(threadId: thread.id, prompt: prompt, image: selectedImage)
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
    
    func retrieveImage(_ fileId: String) async -> Data? {
        var image: Data?
        
        do {
            isLoadingMessages = true
            image = try await openAI.service.fetchFileContent(fileId: fileId)
        } catch {
            errorMessage = "Failed to retrieve images: \(error.localizedDescription)"
            showError = true
        }
        
        isLoadingMessages = false
        return image
    }
    
    func attachImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        if panel.runModal() == .OK, let url = panel.url {
            
            Task {
                do {
                    let imageData = try Data(contentsOf: url)
                    selectedImage = imageData
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
