//
//  MultipartFormDataBuilder.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

import Foundation

struct MultipartFormDataBuilder {
   
   let boundary: String
   let entries: [MultipartFormDataEntry]
   
   init(
      boundary: String,
      entries: [MultipartFormDataEntry])
   {
      self.boundary = boundary
      self.entries = entries
   }
   
   func build() -> Data {
      var httpData = entries
         .map { $0.makeData(boundary: boundary) }
         .reduce(Data(), +)
      httpData.append("--\(boundary)--\r\n")
      return httpData
   }
}

// MARK: MultipartFormDataEntry

enum MultipartFormDataEntry {
   
   case file(paramName: String, fileName: String?, fileData: Data, contentType: String)
   case string(paramName: String, value: Any?)
}

// MARK: MultipartFormDataEntry+Data

extension MultipartFormDataEntry {
   
   func makeData(boundary: String) -> Data {
      var body = Data()
      switch self {
      case .file(let paramName, let fileName, let fileData, let contentType):
         body.append("--\(boundary)\r\n")
         if let fileName = fileName {
             body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n")
         } else {
             body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n")
         }
         body.append("Content-Type: \(contentType)\r\n\r\n")
         body.append(fileData)
         body.append("\r\n")
      case .string(let paramName, let value):
         if let value {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(paramName)\"\r\n\r\n")
            body.append("\(value)\r\n")
         }
      }
      return body
   }
}

private extension Data {
   
   mutating func append(_ string: String) {
      let data = string.data(
         using: String.Encoding.utf8,
         allowLossyConversion: true)
      append(data!)
   }
}
