import Foundation

open class Session {
    public static let `default` = Session()
    
    /// Assign a token to use OpenAI.
    fileprivate var token:String?
    
    public let session: URLSession
    
    public let delegate: SessionDelegate
    
    /// Root `DispatchQueue` for all internal callbacks and state update. **MUST** be a serial queue.
    public let rootQueue: DispatchQueue
    
    /// Creates a `Session` from a `URLSessionConfiguration`.
    public convenience init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {

        // Retarget the incoming rootQueue for safety, unless it's the main queue, which we know is safe.
        let delegate = SessionDelegate()
        
        let rootQueue: DispatchQueue = DispatchQueue(label: "com.janghyo.session.rootQueue")
        let serialRootQueue = (rootQueue === DispatchQueue.main) ? rootQueue : DispatchQueue(label: rootQueue.label, target: rootQueue)
        let delegateQueue = OperationQueue(maxConcurrentOperationCount: 1,
                                           underlyingQueue: serialRootQueue,
                                           name: "\(serialRootQueue.label).sessionDelegate")
        
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: delegate,
                                 delegateQueue: delegateQueue)
        
        self.init(session: session,
                  delegate: delegate,
                  rootQueue: rootQueue)
    }
    
    /// Creates a `Session` from a `URLSession` and other parameters.
    public init(session: URLSession,
                delegate: SessionDelegate,
                rootQueue: DispatchQueue) {
        self.session = session
        self.delegate = delegate
        self.rootQueue = rootQueue
    }
    
    /// Setting the token for using OpenAI
    public func setToken(_ token:String){
        self.token = token
    }
    
    /// Get the token for using OpenAI
    public func getToken() -> String{
        if let token = token {
            return token
        } else {
            return ""
        }
    }
    
    /// Return image links made by OpenAI.
    ///  - Parameters:
    ///     - text: text to convert to image
    ///     - count: image count
    ///     - size : image size
    public func makeImage(text:String,
                          count:Int = 1,
                          size:ImageSize,
                          completion:@escaping (Result<ResponseImageModel, Errors>) -> Void) {
        let body = ImageModel(prompt: text, n: count, size: size.rawValue)
        let request = prepareRequest(.imagesGenerations, body: body)
        
        rootQueue.async { [weak self] in
            guard let self = self else {
                return
            }
            
            let task = self.session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(.general(error: error)))
                } else if let data = data {
                    do {
                        let res = try JSONDecoder().decode(ResponseImageModel.self, from: data)
                        completion(.success(res))
                    } catch {
                        completion(.failure(.decode(error: error)))
                    }
                }
            }
            
            task.resume()
        }
    }
}

//MARK: - Private
extension Session {
    /// Return URLRequest
    ///  - Parameters:
    ///     - endpoint: Endpoint Model
    ///     - body: OpenAI Model
    private func prepareRequest<T: Codable>(_ endpoint: Endpoint, body: T) -> URLRequest {
        var urlComponents = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        var request = URLRequest(url: urlComponents!.url!)
        request.httpMethod = endpoint.method
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(body) {
            request.httpBody = encoded
        }
        
        return request
    }
}
