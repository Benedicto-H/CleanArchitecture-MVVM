//
//  Endpoint.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

typealias ResponseRequestable = Requestable & Responsable

final class Endpoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    var method: HTTPMethodType
    var path: String
    var queryParametersEncodable: (any Encodable)?
    var queryParameters: [String : Any]
    
    var headerParameters: [String : String]?
    
    var bodyParametersEncodable: (any Encodable)?
    var bodyParameters: [String : Any]
    var bodyEncoding: BodyEncoding
    
    var responseDecoder: any ResponseDecoder
    
    init(method: HTTPMethodType = .get,
         path: String,
         queryParametersEncodable: (any Encodable)? = nil,
         queryParameters: [String : Any] = [:],
         headerParameters: [String : String]? = [:],
         bodyParametersEncodable: (any Encodable)? = nil,
         bodyParameters: [String : Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: any ResponseDecoder = JSONResponseDecoder()) {

        self.method = method
        self.path = path
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.headerParameters = headerParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}
