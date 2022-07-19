//
//  PlistCompatible.swift
//  
//
//  Created by Amir Hayek on 17/07/2022.
//

import Foundation

public protocol PlistCompatible {}
extension Optional: PlistCompatible where Wrapped: PlistCompatible {}
extension String: PlistCompatible {}
extension Int: PlistCompatible {}
extension Double: PlistCompatible {}
extension Float: PlistCompatible {}
extension Bool: PlistCompatible {}
extension Date: PlistCompatible {}
extension Data: PlistCompatible {}
extension Array: PlistCompatible where Element: PlistCompatible {}
extension Dictionary: PlistCompatible where Key: PlistCompatible, Value: PlistCompatible {}


