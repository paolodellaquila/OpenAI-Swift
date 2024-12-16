//
//  Thread.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

public struct Thread {
    public let id, object: String
    public let createdAt: Int
    
    static func fromThreadResponse(_ response: ThreadResponse) -> Thread {
        Thread(id: response.id, object: response.object, createdAt: response.createdAt)
    }
}
