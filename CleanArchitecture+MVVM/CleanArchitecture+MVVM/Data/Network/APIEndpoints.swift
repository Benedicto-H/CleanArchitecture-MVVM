//
//  APIEndpoints.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct APIEndpoints {
    
    static func getTrendingRepositories(requestQuery: TrendingRepositoriesRequestQuery) -> Endpoint<TrendingRepositoriesPageDto> {
        
        let responseDecoder = JSONResponseDecoder()
        responseDecoder.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return Endpoint(path: "search/repositories",
                        queryParametersEncodable: requestQuery,
                        responseDecoder: responseDecoder)
    }
    
    static func getImage(path: String, requestQuery: ImagesRequestQuery) -> Endpoint<Data> {
        return Endpoint(path: path,
                        queryParametersEncodable: requestQuery,
                        responseDecoder: RawDataResponseDecoder())
    }
}
