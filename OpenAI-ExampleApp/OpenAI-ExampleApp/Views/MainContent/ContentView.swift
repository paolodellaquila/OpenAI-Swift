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
            List {
                Button("Open New Thread") {
                    viewModel.openThread()
                }
                .buttonStyle(.borderedProminent)
                
                if let thread = viewModel.thread {
                    Section(header: Text("Current Thread")) {
                        Text("ID: \(thread.id)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(minWidth: 200)
            .listStyle(SidebarListStyle())
            .navigationTitle("Threads")
            
            // Center area for chat UI
            VStack {
                if let thread = viewModel.thread {
                    Text("Thread: \(thread.id)")
                        .font(.headline)
                        .padding()
                }
                
                HStack {
                    TextField("Enter Prompt", text: $viewModel.prompt)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    
                    Button("Attach Image") {
                        viewModel.attachImage()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                
                Button("Send Message") {
                    viewModel.createMessage()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.responses, id: \.self) { response in
                            Text(response)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .frame(minWidth: 400)
            .navigationTitle("Chat")
            .alert("Error", isPresented: $viewModel.showError, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(viewModel.errorMessage)
            })
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

#Preview {
    ContentView()
}
