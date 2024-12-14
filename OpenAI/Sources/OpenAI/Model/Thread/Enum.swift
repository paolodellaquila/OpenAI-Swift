//
//  Enum.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

enum ThreadError: Error {
    case threadNotFound
    case invalidResponse
    case invalidResponseStatus
    case invalidRequestBody
}
