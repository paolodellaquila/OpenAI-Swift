public struct MessageContentResponse: Codable {
    public let type: ContentType
    public let text: TextContentResponse?
    public let imageFile: ImageFileContentResponse?
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageFile = "image_file"
    }
    
    public enum ContentType: String, Codable {
        case text
        case imageFile = "image_file"
    }
    
    // Custom decoding to handle polymorphic types
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ContentType.self, forKey: .type)
        
        switch type {
        case .text:
            self.text = try container.decodeIfPresent(TextContentResponse.self, forKey: .text)
            self.imageFile = nil
        case .imageFile:
            self.imageFile = try container.decodeIfPresent(ImageFileContentResponse.self, forKey: .imageFile)
            self.text = nil
        }
    }
}

// MARK: - TextContentResponse
public struct TextContentResponse: Codable {
    public let value: String
    public let annotations: [String]
}

// MARK: - ImageFileContentResponse
public struct ImageFileContentResponse: Codable {
    public let fileID: String
    public let detail: String
    
    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case detail
    }
}
