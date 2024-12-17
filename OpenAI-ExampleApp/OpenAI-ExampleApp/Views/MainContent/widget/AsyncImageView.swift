//
//  AsyncImageView.swift
//  OpenAI-ExampleApp
//
//  Created by Francesco Paolo Dellaquila on 17/12/24.
//

import SwiftUI

struct AsyncImageView: View {
    let fileId: String
    @ObservedObject var viewModel: ContentViewModel
    @State private var image: NSImage? = nil
    
    var body: some View {
        Group {
            if let loadedImage = image {
                Image(nsImage: loadedImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView() // Show a loading indicator while fetching
                    .onAppear {
                        Task {
                            image = await viewModel.loadImage(for: fileId)
                        }
                    }
            }
        }
    }
}
