//
//  Run.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

public struct Run {
    
    public let id: String
    public let object: String
    public let createdAt: Int?
    public let threadID: String
    public let assistantID: String
    public let status: String
    
    static func fromRunResponse(_ runResponse: RunResponse) -> Run {
        Run(id: runResponse.id,
            object: runResponse.object,
            createdAt: runResponse.createdAt,
            threadID: runResponse.threadID,
            assistantID: runResponse.assistantID,
            status: runResponse.status)
    }
    
    static func fromRunResponse(_ runResponse: [RunResponse]) -> [Run] {
        runResponse.map(Run.fromRunResponse)
    }
    
}
