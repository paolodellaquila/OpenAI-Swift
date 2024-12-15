//
//  Authorization.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

public enum Authorization {
    case apiKey(String)
    case bearer(String)

    var headerField: String {
        switch self {
        case .apiKey:
            "api-key"
        case .bearer:
            "Authorization"
        }
    }

    var value: String {
        switch self {
        case .apiKey(let value):
            value
        case .bearer(let value):
            "Bearer \(value)"
        }
    }
}
