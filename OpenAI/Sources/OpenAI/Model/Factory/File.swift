//
//  File.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 16/12/24.
//

public struct File {
    
    public let id: String
    public let bytes: Int?
    public let createdAt: Int
    public let filename: String
    
    static func fromFileResponse(_ response: FileResponse) -> File {
        File(id: response.id, bytes: response.bytes, createdAt: response.createdAt, filename: response.filename)
    }
    
    static func fromFileResponse(_ response: [FileResponse]) -> [File] {
        response.map(File.fromFileResponse)
    }
}
