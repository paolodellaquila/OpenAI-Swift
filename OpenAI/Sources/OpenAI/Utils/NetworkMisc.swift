//
//  NetworkUtils.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation

private func printHTTPURLResponse(
   _ response: HTTPURLResponse,
   data: Data? = nil)
{
#if DEBUG
   print("\n- - - - - - - - - - INCOMING RESPONSE - - - - - - - - - -\n")
   print("URL: \(response.url?.absoluteString ?? "No URL")")
   print("Status Code: \(response.statusCode)")
   print("Headers: \(response.allHeaderFields)")
   if let mimeType = response.mimeType {
      print("MIME Type: \(mimeType)")
   }
   if let data = data, response.mimeType == "application/json" {
      print("Body: \(prettyPrintJSON(data))")
   } else if let data = data, let bodyString = String(data: data, encoding: .utf8) {
      print("Body: \(bodyString)")
   }
   print("\n- - - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
#endif
}


private func prettyPrintJSON(
   _ data: Data)
   -> String
{
   guard
      let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
      let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
      let prettyPrintedString = String(data: prettyData, encoding: .utf8) else { return "Could not print JSON - invalid format" }
   return prettyPrintedString
}

private func printHTTPURLResponse(
   _ response: HTTPURLResponse,
   data: Data? = nil)
{
#if DEBUG
   print("\n- - - - - - - - - - INCOMING RESPONSE - - - - - - - - - -\n")
   print("URL: \(response.url?.absoluteString ?? "No URL")")
   print("Status Code: \(response.statusCode)")
   print("Headers: \(response.allHeaderFields)")
   if let mimeType = response.mimeType {
      print("MIME Type: \(mimeType)")
   }
   if let data = data, response.mimeType == "application/json" {
      print("Body: \(prettyPrintJSON(data))")
   } else if let data = data, let bodyString = String(data: data, encoding: .utf8) {
      print("Body: \(bodyString)")
   }
   print("\n- - - - - - - - - - - - - - - - - - - - - - - - - - - -\n")
#endif
}
