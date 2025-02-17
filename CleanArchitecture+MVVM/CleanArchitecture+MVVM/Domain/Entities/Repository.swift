//
//  Repository.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

struct Repository: Hashable {
    
    let id: Int
    let owner: Owner
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String?
}
