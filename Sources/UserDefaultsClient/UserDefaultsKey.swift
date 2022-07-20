//
//  SFGUserDefaultsKey.swift
//  
//
//  Created by Amir Hayek on 17/07/2022.
//

protocol OptionalType {
    associatedtype Wrapped
}
extension Optional: OptionalType {}

public struct UserDefaultsKey<A: Codable> {
    let key: String
    let `default`: A?
    
    fileprivate init(key: String) {
        self.key = key
        self.default = nil
    }
    
    init(key: String, `default`: A) {
        self.key = key
        self.default = `default`
    }
    
//    @available(*, unavailable, message: "This key needs a `defaultValue` parameter. If this type does not have a default value, consider using an optional key.")
//    init(_ key: String) {
//        fatalError()
//    }
    
}

extension UserDefaultsKey where A:Codable, A: OptionalType, A.Wrapped:Codable {
    init(key: String) {
        self.key = key
        self.default = nil
    }
}
