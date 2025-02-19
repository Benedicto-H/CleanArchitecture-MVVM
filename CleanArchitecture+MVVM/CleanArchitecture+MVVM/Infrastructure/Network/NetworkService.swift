//
//  NetworkService.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

enum NetworkError: Error {
    
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

protocol NetworkService {
    
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
    func url(for endpoint: Requestable) throws -> URL
}

protocol NetworkSessionManager {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkLogger {
    
    func log(request: URLRequest) -> Void
    func log(responseData data: Data?, response: URLResponse?) -> Void
    func log(error: Error) -> Void
}

// MARK: - Network Service Implementation
final class NetworkServiceImpl {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkLogger
    
    init(config: NetworkConfigurable = ApiDataNetworkConfig(),
         sessionManager: NetworkSessionManager = NetworkSessionManagerImpl(),
         logger: NetworkLogger = NetworkLoggerImpl()) {
        
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

// MARK: - Network Session Manager Implementation
final class NetworkSessionManagerImpl: NetworkSessionManager {
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        
        return task
    }
}

// MARK: - Network Logger Implementation
final class NetworkLoggerImpl: NetworkLogger {
    
    private let shouldLogRequests: Bool
    
    init(shouldLogRequests: Bool = true) {
        self.shouldLogRequests = shouldLogRequests
    }
    
    func log(request: URLRequest) {
        
        guard shouldLogRequests else { return }
        
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        
        if let httpBody = request.httpBody,
           let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody,
                  let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
        guard shouldLogRequests else { return }
        guard let data = data else { return }
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }
    
    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - Extensions
extension NetworkError {
    
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        
        switch self {
        case let .error(code, _): return code == codeError
        default: return false
        }
    }
}

extension URLSessionTask: NetworkCancellable { }

extension NetworkServiceImpl: NetworkService {
    
    func request(endpoint: any Requestable, completion: @escaping CompletionHandler) -> (any NetworkCancellable)? {
        
        do {
            
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
    func url(for endpoint: any Requestable) throws -> URL {
        try endpoint.makeURL(with: config)
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        
        var string: String = ""
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        
        return string
    }
}

func printIfDebug(_ string: String) -> Void {
    
    #if DEBUG
    print(string)
    #endif
}
