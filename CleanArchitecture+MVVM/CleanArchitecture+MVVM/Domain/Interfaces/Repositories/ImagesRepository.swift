//
//  ImagesRepository.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

protocol ImagesRepository {
    func fetchImage(with imagePath: String, size: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
