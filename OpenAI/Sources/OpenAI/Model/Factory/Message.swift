//
//  Thread 2.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//


public struct Message {
    let id, object: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case id, object
        case createdAt = "created_at"
    }
    
    static func fromThreadResponse(_ response: ThreadResponse) -> Thread {
        Thread(id: response.id, object: response.object, createdAt: response.createdAt)
    }
}
