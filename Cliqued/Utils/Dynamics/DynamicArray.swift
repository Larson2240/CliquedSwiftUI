//
//  DynamicArray.swift
//  iOSStyleguide
//
//  Created by Pavle Pesic on 5/8/18.
//  Copyright © 2018 Fabrika. All rights reserved.
//

import Foundation

enum ListenerToFire {
    case Add
    case Remove
    case Default
}

class DynamicArray<T>: DynamicAsync<[T]> {
    
    // MARK: - typealias
    
    typealias RemoveListener = (Int) -> ()
    typealias AddListener = ((Int)) -> ()
    
    // MARK: - Vars & Lets
    
    var removeListener: RemoveListener?
    var appendListener: AddListener?
    
    var listenerToFire = ListenerToFire.Default
    
    override func fire() {
        if listenerToFire == .Default {
            listener?(value)
        }
        listenerToFire = .Default
    }
    
    // MARK: - Public methods
    
    func append(_ element: T) {
        listenerToFire = .Add
        value.append(contentsOf: [element])
        appendListener?(value.count)
    }
    
    func append(_ contentsOf: [T]) {
        listenerToFire = .Add
        value.append(contentsOf: contentsOf)
        appendListener?(contentsOf.count)
    }
    
    func remove(_ at: Int) {
        listenerToFire = .Remove
        value.remove(at: at)
        removeListener?(at)
    }
    
    func bindRemoveListener(_ listener: RemoveListener?) {
        removeListener = listener
    }
    
    func bindAppendListener(_ listener: AddListener?) {
        appendListener = listener
    }
    
}
