//
//  UndoManagerExtension.swift
//  Sylex
//

import Foundation

@available(OSX 10.11, *)
public extension UndoManager {
    func registerUndo<TargetType: AnyObject, ValueType>(for key: ReferenceWritableKeyPath<TargetType, ValueType>, of target: TargetType, with actionName: String? = nil) {
        let value: ValueType = target[keyPath: key]
        if let name = actionName { self.setActionName(name) }
        self.registerUndo(withTarget: target) { $0[keyPath: key] = value }
    }
}
