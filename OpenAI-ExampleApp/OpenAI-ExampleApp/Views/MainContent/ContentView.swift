//
//  ContentView.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import SwiftUI
import OpenAI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            // Sidebar for thread management
            VStack {
                if viewModel.isLoadingThreads {
                    ProgressView("Loading Threads...")
                } else {
                    List(viewModel.threads, id: \.id) { thread in
                        Button(action: {
                            viewModel.loadMessages(thread)
                        }) {
                            Text(thread.id)
                                .font(.body)
                        }
                    }
                }
                Button("Add New Thread") {
                    viewModel.openThread()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .frame(minWidth: 200)
            .listStyle(SidebarListStyle())
            .navigationTitle("Threads")
            
            // Center chat UI
            VStack {
                if viewModel.isLoadingMessages {
                    ProgressView("Loading Messages...")
                } else if let selectedThread = viewModel.selectedThread {
                    Text("Thread: \(selectedThread.id)")
                        .font(.headline)
                        .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.messages, id: \.id) { message in
                                
                                if let fileId = message.content.first?.imageFile?.imageFile.fileID {
                                    AsyncImageView(fileId: fileId, viewModel: viewModel)
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                
                                if message.content.first?.text != nil {
                                    Text(message.content.first?.text?.text.value ?? "")
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    // Attached Image Preview Bar
                    if let imageData = viewModel.selectedImage {
                        HStack {
                            if let image = NSImage(data: imageData) {
                                Image(nsImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            
                            Text("Image Selected")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.removeImage()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        TextField("Enter Prompt", text: $viewModel.prompt)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            viewModel.attachImage()
                        }) {
                            Image(systemName: "paperclip")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.borderless) // Prevents button from looking like a bordered button
                        .padding(.horizontal, 5)
                        
                        Button("Send") {
                            viewModel.createMessage()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    Text("Select or create a thread to start chatting")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .frame(minWidth: 400)
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            viewModel.loadThreads()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    ContentView()
}
