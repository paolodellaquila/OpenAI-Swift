//
//  Enum.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

/**
 An enumeration of possible errors related to threads.
 */
enum ThreadError: Error {
    case threadNotFound
    case invalidResponse
    case invalidResponseStatus
    case invalidRequestBody
}
