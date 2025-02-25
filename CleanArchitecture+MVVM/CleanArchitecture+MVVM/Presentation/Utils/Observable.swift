//
//  Observable.swift
//  CleanArchitecture+MVVM
//
//  Created by 홍진표 on 2/21/25.
//

import Foundation

final class Observable<Element> {
    
    struct Observer<Element> {
        
        weak var observer: AnyObject?
        let block: (Element) -> Void
    }
    
    private var observers = [Observer<Element>]()
    var value: Element {
        didSet { notifyObservers() }
    }
    
    init(_ value: Element) {
        self.value = value
    }
    
    func observe(on observer: AnyObject, observerBlock: @escaping (Element) -> Void) -> Void {
        
        observers.append(Observer(observer: observer, block: observerBlock))
        observerBlock(self.value)
    }
    
    func remove(observer: AnyObject) -> Void {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() -> Void {
        
        for observer in observers {
            observer.block(self.value)
        }
    }
}
