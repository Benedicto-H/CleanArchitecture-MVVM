//
//  ImagesRequestQuery.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/18/25.
//

import Foundation

struct ImagesRequestQuery: Encodable {
    
    let size: Int
    
    private enum CodingKeys: String, CodingKey {
        case size = "s"
    }
}
