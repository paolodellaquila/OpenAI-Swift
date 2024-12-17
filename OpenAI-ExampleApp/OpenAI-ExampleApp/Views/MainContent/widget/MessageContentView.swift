//
//  MessageContentView.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//

import SwiftUI
import OpenAI

struct MessageContentView: View {
    let content: MessageContent
    
    var body: some View {
        if let fileId = content.imageFile?.imageFile.fileID {
            AsyncImageView(fileId: fileId, viewModel: ContentViewModel())
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
        }
        
        if let text = content.text {
            Text(text.text.value)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
        }
    }
}
