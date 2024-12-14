//
//  Context.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 14/12/24.
//

/**
 A private class to manage thread-specific data.
 */
class ThreadContext {
    let id: String
    var prompts: [String]

    init(id: String, prompts: [String]) {
        self.id = id
        self.prompts = prompts
    }
}
