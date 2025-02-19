//
//  RepositoryTask.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

class RepositoryTask: Cancellable {
    
    var networkTask: NetworkCancellable?
    var isCancelled = false
    
    func cancel() {
        
        networkTask?.cancel()
        isCancelled = true
    }
}
