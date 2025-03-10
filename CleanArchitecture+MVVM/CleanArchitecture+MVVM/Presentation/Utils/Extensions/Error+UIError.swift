//
//  Error+UIError.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/25/25.
//

import Foundation

enum UIError {
    
    case notConnectedToInternet
    case cancelled
    case generic(Error)
}

extension Error {
    var uiError: UIError {
        if let error = self as? DataTransferError,
           case DataTransferError.networkFailure(let networkError) = error {
            
            switch networkError {
            case .notConnected: return .notConnectedToInternet
            case .cancelled: return .cancelled
            default: return .generic(self)
            }
        }
        return .generic(self)
    }
}
