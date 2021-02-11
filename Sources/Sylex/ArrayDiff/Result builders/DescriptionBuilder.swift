//
//  File.swift
//  
//
//  Created by Pierre Tacchi on 09/02/21.
//

@resultBuilder
public struct DescriptionBuilder {
    public static func buildBlock(_ component: String) -> String { component }
    public static func buildEither(first component: String) -> String { component }
    public static func buildEither(second component: String) -> String { component }
}
