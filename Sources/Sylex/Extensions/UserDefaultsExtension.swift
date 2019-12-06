//
//  File.swift
//  
//
//  Created by Pierre TACCHI on 06/12/2019.
//

import Foundation

public extension UserDefaults {
    
    /// Sets the value of the specified default key to the specified enum value.
    /// - Precondition: The enum must implement `RawReprensentable` and `RawValue` must be `Int`.
    /// - Parameters:
    ///   - value: The enum value to store in the defaults database.
    ///   - defaultName: The key with which to associate the value.
    func set<T: RawRepresentable>(_ value: T, forKey defaultName: String) where T.RawValue == Int {
        self.set(value.rawValue, forKey: defaultName)
    }
    
    /// Returns the enum value associated with the specified key.
    /// - Precondition: The enum must implement `RawReprensentable` and `RawValue` must be `Int`.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func integerEnum<T: RawRepresentable>(forKey defaultName: String) -> T? where T.RawValue == Int {
        T(rawValue: self.integer(forKey: defaultName))
    }
}
