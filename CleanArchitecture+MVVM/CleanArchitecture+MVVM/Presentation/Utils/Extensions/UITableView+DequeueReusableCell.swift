//
//  UITableView+DequeueReusableCell.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/25/25.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(_ cellType: Cell.Type, registeredCellTypes: inout Set<String>) -> Cell {
        
        let identifier = String(describing: cellType)
        
        if !registeredCellTypes.contains(identifier) {
            
            register(cellType, forCellReuseIdentifier: identifier)
            registeredCellTypes.insert(identifier)
        }
        
        let dequeuedCell = dequeueReusableCell(withIdentifier: identifier)
        
        guard let cell = dequeuedCell as? Cell else {
            assertionFailure("Cannot dequeue reusable cell \(TrendingRepositoriesListItemCell.self) with reuseIdentifier: \(identifier)")
            
            return Cell()
        }
        
        return cell
    }
}
