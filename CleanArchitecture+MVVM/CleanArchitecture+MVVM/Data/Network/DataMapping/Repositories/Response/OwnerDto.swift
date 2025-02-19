//
//  OwnerDto.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct OwnerDto: Decodable {
    
    let id: Int
    let login: String
    let avatarUrl: String
}

extension OwnerDto {
    func toDomain() -> Owner {
        return Owner(id: id,
                     name: login,
                     avatarUrl: avatarUrl)
    }
}
