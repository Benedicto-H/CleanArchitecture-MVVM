//
//  Requestable.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

enum HTTPMethodType: String {
    
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum BodyEncoding {
    
    case jsonSerializationData
    case stringEncodingAscii
}

enum RequestGenerationError: Error {
    
    case components
    case urlPathIsInvalid
}

protocol Requestable {
    //  HTTP 요청 메시지
    /// 1. Request Line
    var method: HTTPMethodType { get }  //  Method
    var path: String { get }            //  Request URI
    var queryParametersEncodable: Encodable? { get } //  Request URI (Query는 요청 URI의 일부)
    var queryParameters: [String : Any] { get }
    
    /// 2. Request Headers
    var headerParameters: [String : String]? { get }    //  = headerFields
    
    /// 3. Empty Line
    
    /// 4. Request Body
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String : Any] { get }
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

// MARK: - Requestable+
extension Requestable {
    
    func makeURL(with config: NetworkConfigurable) throws -> URL {
        
        let endpoint: String
        
        if let baseURL = config.baseURL {
            
            let baseURL = baseURL.absoluteString.last != "/" ? (baseURL.absoluteString + "/") : (baseURL.absoluteString)
            endpoint = baseURL.appending(path)
        } else {
            endpoint = path
        }
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()
        
          let queryParameters = try  queryParametersEncodable?.toDictionary() ?? self.queryParameters
        
        queryParameters.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)")) }
        config.queryParameters.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
        
        urlComponents.queryItems = urlQueryItems.isEmpty ? urlComponents.queryItems : (urlComponents.queryItems ?? []) + urlQueryItems
        
        guard let url: URL = urlComponents.url else { throw RequestGenerationError.components }
        
        if urlComponents.queryItems?.isEmpty ?? true {
            
            guard let url = URL(string: endpoint) else { throw RequestGenerationError.urlPathIsInvalid }
            return url
        }
        
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        
        let url = try makeURL(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders = config.headers
        
        headerParameters?.forEach { allHeaders.updateValue($1, forKey: $0) }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
    
    private func encodeBody(bodyParameters: [String : Any], bodyEncoding: BodyEncoding) -> Data? {
        
        switch bodyEncoding {
            
        case .jsonSerializationData: return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii: return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data) as? [String : Any]
        
        return dictionary
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}
