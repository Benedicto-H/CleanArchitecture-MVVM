//
//  Provider.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

enum DataTransferError: Error {
    
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) -> Void
}

protocol DataTransferServiceProvider {
    
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T: Decodable, E: ResponseRequestable, E.Response == T
    
    @discardableResult
    func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E: ResponseRequestable, E.Response == Void
    
    @discardableResult
    func request<T, E>(with endpoint: E, on queue: DataTransferDispatchQueue, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T: Decodable, E: ResponseRequestable, E.Response == T
    
    @discardableResult
    func request<E>(with endpoint: E, on queue: DataTransferDispatchQueue, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E: ResponseRequestable, E.Response == Void
    
    func makeURL<E>(for endpoint: E) throws -> URL where E: ResponseRequestable
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

protocol ResponseDecoder {
    func decode<T>(_ data: Data) throws -> T where T: Decodable
}

// MARK: - Response Decoders
final class JSONResponseDecoder: ResponseDecoder {
    
    let jsonDecoder = JSONDecoder()
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

final class RawDataResponseDecoder: ResponseDecoder {
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        
        if T.self is Data.Type, let data = data as? T { return data } else {
            
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
