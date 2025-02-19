//
//  ImagesStorage.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

protocol ImagesStorage {
    
    func getImageData(for urlPath: String, completion: @escaping (Result<Data?, Error>) -> Void) -> Void
    func save(imageData: Data, for urlPath: String)
}
