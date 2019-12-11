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
    func set<EnumType: RawRepresentable>(_ value: EnumType, forKey defaultName: String) where EnumType.RawValue == Int {
        self.set(value.rawValue, forKey: defaultName)
    }
    
    /// Returns the enum value associated with the specified key.
    /// - Precondition: The enum must implement `RawReprensentable` and `RawValue` must be `Int`.
    /// - Parameter defaultName: A key in the current user‘s defaults database.
    func integerEnum<EnumType: RawRepresentable>(forKey defaultName: String) -> EnumType? where EnumType.RawValue == Int {
        EnumType(rawValue: self.integer(forKey: defaultName))
    }
}
