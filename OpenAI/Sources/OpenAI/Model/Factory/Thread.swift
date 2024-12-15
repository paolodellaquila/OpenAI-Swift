//
//  Thread.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

public struct AIThread {
    let id, object: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
    }
    
    static func fromThreadResponse(_ response: ThreadResponse) -> AIThread {
        AIThread(id: response.id, object: response.object, createdAt: response.createdAt)
    }
}
