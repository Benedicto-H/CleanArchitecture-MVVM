//
//  UIViewController+AddChild.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/25/25.
//

import Foundation
import UIKit

extension UIViewController {
    
    func add(child: UIViewController, container: UIView) -> Void {
        
        addChild(child)
        
        child.view.frame = container.bounds
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() -> Void {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
