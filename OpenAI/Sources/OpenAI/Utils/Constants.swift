//
//  Constants.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

class Constants {
    static let apiKey = ""
    
    private static let apiURL = "https://api.openai.com"
    private static let version = "v1"
    
    static func urlResolver(endpoint: Endpoint) -> String {
        return "\(apiURL)/\(version)/\(endpoint.rawValue)/"
    }
}
