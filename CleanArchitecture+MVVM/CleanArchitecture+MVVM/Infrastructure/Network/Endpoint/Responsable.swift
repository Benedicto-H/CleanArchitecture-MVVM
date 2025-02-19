//
//  Responsable.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/17/25.
//

import Foundation

protocol Responsable<Response> {
    
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}
