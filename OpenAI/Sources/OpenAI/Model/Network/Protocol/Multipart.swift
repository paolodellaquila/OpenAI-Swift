//
//  Multipart.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

import Foundation

public protocol MultipartFormDataParameters {
   
   func encode(boundary: String) -> Data
}
