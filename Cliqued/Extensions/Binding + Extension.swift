//
//  Binding + Extension.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 05.10.2023.
//

import SwiftUI

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
