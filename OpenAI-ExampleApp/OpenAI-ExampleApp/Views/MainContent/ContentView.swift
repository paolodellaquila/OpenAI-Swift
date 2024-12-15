//
//  ContentView.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

import SwiftUI
import OpenAI

struct ContentView: View {
    @StateObject private var viewModel = OpenAIViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("OpenAI Swift Package Demo")
                    .font(.title)
                    .bold()
                
                Button("Open New Thread") {
                    viewModel.openThread()
                }
                .buttonStyle(.borderedProminent)
                
                if let threadId = viewModel.threadId {
                    Text("Current Thread ID: \(threadId)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                TextField("Enter Prompt", text: $viewModel.prompt)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Send Request") {
                    viewModel.sendRequest()
                }
                .buttonStyle(.bordered)
                
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
                
                Spacer()
            }
            .padding()
            .navigationTitle("OpenAI Demo")
            .alert("Error", isPresented: $viewModel.showError, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(viewModel.errorMessage)
            })
        }
    }
}


#Preview {
    ContentView()
}
