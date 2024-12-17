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
    @Published var streamedResponse: [String: String] = [:] // Partial streamed response preview
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoadingThreads: Bool = false // Loading state for threads
    @Published var isLoadingMessages: Bool = false // Loading state for messages
    @Published var isThreadRunning: Bool = false // Loading state for run thread
    
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
        
        return nil
    }

}


//-- Thread
extension ContentViewModel {
    
    func loadThreads() {
        Task {
            do {
                isLoadingThreads = true
                threads = try await openAI.service.fetchThreads()
                
                ///Prepare stream content
                for thread in threads {
                    streamedResponse[thread.id] = ""
                }
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
    
    func deleteThread(_ thread: AIThread) {
        Task {
            do {
                try await openAI.service.deleteThread(threadId: thread.id)
                threads.removeAll { $0.id == thread.id }
            } catch {
                errorMessage = "Failed to delete thread: \(error.localizedDescription)"
                showError = true
            }
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
                selectedImage = nil // Clear selected image after sending
                streamedResponse[thread.id] = nil
            } catch {
                errorMessage = "Failed to send message: \(error.localizedDescription)"
                showError = true
            }
            
            isLoadingMessages = false
            await run(thread.id)
        }
    }
    
    func loadMessages(_ thread: AIThread) {
        Task {
            do {
                selectedThread = thread
                isLoadingMessages = true
                messages = try await openAI.service.fetchMessages(threadId: thread.id)
                streamedResponse[thread.id] = nil
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

// -- Run
extension ContentViewModel {
    
    func run(_ threadId: String) async {
        
        isThreadRunning = true
        streamedResponse[threadId] = "" // Reset previous response
        
        do {
            let stream = try await openAI.service.createRun(threadId: threadId)
            
            for try await result in stream {
                switch result {
                case .threadMessageDelta(let messageDelta):
                    if let content = messageDelta.delta.content.first {
                        switch content {
                        case .text(let textDelta):
                            streamedResponse[threadId]! += textDelta.text.value
                        case .imageFile(_):
                            break
                        }
                    }
                default:
                    break
                }
            }
        } catch {
            errorMessage = "Failed to stream content: \(error.localizedDescription)"
            showError = true
        }
        
        isThreadRunning = false
    }
}

