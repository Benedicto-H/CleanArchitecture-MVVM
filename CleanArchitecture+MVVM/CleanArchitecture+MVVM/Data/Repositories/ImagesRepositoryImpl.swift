//
//  DefaultImagesRepository.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

enum ImagesRepositoryError: Error {
    case invalidPathUrl
}

final class ImagesRepositoryImpl {
    
    private let dataTransferServiceProvider: DataTransferServiceProvider
    private let imagesCache: ImagesStorage
    private let backgroundQueue: DataTransferDispatchQueue
    
    init(dataTransferServiceProvider: DataTransferServiceProvider,
         imagesCache: ImagesStorage,
         backgroundQueue: DataTransferDispatchQueue) {
        
        self.dataTransferServiceProvider = dataTransferServiceProvider
        self.imagesCache = imagesCache
        self.backgroundQueue = backgroundQueue
    }
}

extension ImagesRepositoryImpl: ImagesRepository {
    func fetchImage(with imagePath: String, size: Int, completion: @escaping (Result<Data, any Error>) -> Void) -> (any Cancellable)? {
        
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getImage(path: imagePath, requestQuery: ImagesRequestQuery(size: size))
        
        guard let pathUrlWithPath = try? dataTransferServiceProvider.makeURL(for: endpoint).absoluteString else {
            completion(.failure(ImagesRepositoryError.invalidPathUrl))
            return task
        }
        
        imagesCache.getImageData(for: pathUrlWithPath) { [dataTransferServiceProvider, backgroundQueue, imagesCache] result in
            
            if case let .success(imageData?) = result {
                completion(.success(imageData))
                return
            }
            
            guard !task.isCancelled else { return }
            
            task.networkTask = dataTransferServiceProvider.request(with: endpoint, on: backgroundQueue, completion: { [imagesCache] (result: Result<Data, DataTransferError>) in
                if case let .success(imageData) = result {
                    imagesCache.save(imageData: imageData, for: pathUrlWithPath)
                }
                
                let result = result.mapError { $0 as Error }
                completion(result)
            })
        }
        
        return task
    }
}
