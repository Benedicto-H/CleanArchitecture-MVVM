//
//  DefaultDataTransferServiceProvider.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

final class DataTransferServiceImpl {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(networkService: NetworkService,
         errorResolver: DataTransferErrorResolver = DataTransferErrorResolverImpl(),
         errorLogger: DataTransferErrorLogger = DataTransferErrorLoggerImpl()) {
        
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

final class DataTransferErrorResolverImpl: DataTransferErrorResolver {
    func resolve(error: NetworkError) -> any Error {
        return error
    }
}

final class DataTransferErrorLoggerImpl: DataTransferErrorLogger {
    func log(error: any Error) {
        
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - DataTransferServiceImpl+
extension DataTransferServiceImpl: DataTransferServiceProvider {
    
    func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> (any NetworkCancellable)? where T : Decodable, T == E.Response, E : Requestable, E : Responsable {
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
    }
    
    func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> (any NetworkCancellable)? where E : Requestable, E : Responsable, E.Response == () {
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
    }
    
    func request<T, E>(with endpoint: E, on queue: any DataTransferDispatchQueue, completion: @escaping CompletionHandler<T>) -> (any NetworkCancellable)? where T : Decodable, T == E.Response, E : Requestable, E : Responsable {
        
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                queue.asyncExecute { completion(result) }
            case .failure(let error):
                
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
    }
    
    func request<E>(with endpoint: E, on queue: any DataTransferDispatchQueue, completion: @escaping CompletionHandler<Void>) -> (any NetworkCancellable)? where E : Requestable, E : Responsable, E.Response == () {
        
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success: queue.asyncExecute { completion(.success(())) }
            case .failure(let error):
                
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
    }
    
    func makeURL<E>(for endpoint: E) throws -> URL where E : Requestable, E : Responsable {
        try networkService.url(for: endpoint)
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        
        do {
            
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
}
