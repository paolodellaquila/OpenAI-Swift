//
//  FetchMessagesConfig.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//


public struct FetchMessagesConfig {
    public var limit: Int? = 50
    public var order: String? = "asc"
    public var after: String? = nil
    public var before: String? = nil
    public var runID: String? = nil
}
