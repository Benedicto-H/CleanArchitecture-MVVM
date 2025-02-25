//
//  DispatchQueueType.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/25/25.
//

import Foundation

protocol DispatchQueueType {
    func async(execute work: @escaping () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        async(group: nil, execute: work)
    }
}
