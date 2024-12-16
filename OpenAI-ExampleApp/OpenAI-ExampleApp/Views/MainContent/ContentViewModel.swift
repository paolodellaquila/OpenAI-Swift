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
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoadingThreads: Bool = false // Loading state for threads
    @Published var isLoadingMessages: Bool = false // Loading state for messages
    
    private let openAI = OpenAI()
    
    // Load cached threads
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
    
    // Add a new thread
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
    
    // Select a thread and load its messages
    func selectThread(_ thread: AIThread) {
        Task {
            do {
                selectedThread = thread
                isLoadingMessages = true
                messages = try await openAI.service.fetchMessages(threadId: thread.id, limit: nil, order: nil, after: nil, before: nil, runID: nil)
            } catch {
                errorMessage = "Failed to load messages: \(error.localizedDescription)"
                showError = true
            }
            isLoadingMessages = false
        }
    }
    
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
}
