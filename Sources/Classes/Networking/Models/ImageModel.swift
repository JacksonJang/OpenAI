import Foundation

public struct ImageModel: Codable {
    let prompt: String
    let n: Int
    let size: String
    
    enum CodingKeys:String, CodingKey {
        case prompt, n, size
    }
}

public struct ResponseImageModel: Codable {
    let created: Int
    let data: [URLData]
    
    enum CodingKeys: String, CodingKey {
        case created, data
    }
}

public struct URLData: Codable {
    let url: String
}
