//
//  RepositoryDto.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct RepositoryDto: Decodable {
    
    let id: Int
    let owner: OwnerDto
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String?
}

extension RepositoryDto {
    func toDomain() -> Repository {
        return Repository(id: id,
                          owner: owner.toDomain(),
                          name: name,
                          description: description,
                          stargazersCount: stargazersCount,
                          language: language)
    }
}
