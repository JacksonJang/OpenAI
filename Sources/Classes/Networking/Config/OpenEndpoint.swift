import Foundation

enum Endpoint {
    case imagesGenerations
}

//API Docs Link : https://beta.openai.com/docs/api-reference/introduction
extension Endpoint {
    var path: String {
        switch self {
        case .imagesGenerations:
            return "/v1/images/generations"
        }
    }
    
    var method: String {
        return HTTPMethod.post.rawValue
    }
    
    var baseURL: URL {
        return URL(string: "https://api.openai.com")!
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json",
                "Authorization":"Bearer \(OpenAI.getToken())"]
    }
}
