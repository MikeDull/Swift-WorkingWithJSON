//
//  JSONDecoderWithKeyPath.swift
//  JSONParser
//
//  Created by Mike Dull on 2019/12/11.
//  Copyright © 2019 MikeDull. All rights reserved.
//

import Foundation

// Protocol for data structure which would use json decoder to extract data
protocol JSONDecodable {
    init(decoder: JSONDecoderWithKeyPath) throws
}

// Error Type
enum JSONDecoderWithKeyPathError: Error {
    case keyNotFound(String)
    case keyPathNotFound(String)
}

// Structure for extract data from JSON by key path
struct JSONDecoderWithKeyPath {
    
    private let jsonData: [String:AnyObject]
    
    init(data: [String:AnyObject]) {
        self.jsonData = data
    }
    
    func decode<T>(key: String) throws -> T {
        
        guard let value: T = try? value(forKey: key) else {
            throw JSONDecoderWithKeyPathError.keyNotFound(key)
        }
        
        return value
    }
    
    private func value<T>(forKey key: String) throws -> T {
        
        if key.contains(".") {
            return try value(forKeyPath: key)
        }
        
        guard let value = jsonData[key] as? T else {
            throw JSONDecoderWithKeyPathError.keyNotFound(key)
        }
        
        return value
    }
    
    private func value<T>(forKeyPath keyPath: String) throws -> T {
        
        var partial = jsonData
        let keys = keyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialJSONData = partial[keys[i]] as? [String:AnyObject] {
                    partial = partialJSONData
                } else {
                    break
                }
            } else {
                return try JSONDecoderWithKeyPath(data: partial).value(forKey: keys[i])
            }
        }
        
        throw JSONDecoderWithKeyPathError.keyPathNotFound(keyPath)
    }
    
    
    // Support for arrays
    
    func decode<T: JSONDecodable>(key: String) throws -> [T] {
        
        if key.contains(".") {
            return try value(forKeyPath: key)
        }
        
        if let value: [T] = try value(forKey: key) {
            return value
        } else {
            throw JSONDecoderWithKeyPathError.keyNotFound(key)
        }
    }
    
    private func value<T: JSONDecodable>(forKey key: String) throws -> [T] {
        
        guard let data = jsonData[key] as? [[String:AnyObject]] else {
            throw JSONDecoderWithKeyPathError.keyNotFound(key)
        }
        
        return try data.map { (partial) -> T in
            let jsonDecoder = JSONDecoderWithKeyPath(data: partial)
            return try T(decoder: jsonDecoder)
        }
    }
    
    private func value<T: JSONDecodable>(forKeyPath KeyPath: String) throws -> [T] {
        
        var partial = jsonData
        let keys = KeyPath.components(separatedBy: ".")
        
        for i in 0..<keys.count {
            if i < keys.count - 1 {
                if let partialData = partial[keys[i]] as? [String:AnyObject] {
                    partial = partialData
                } else {
                    break
                }
            } else {
                return try JSONDecoderWithKeyPath(data: partial).value(forKey: keys[i])
            }
        }
        
        throw JSONDecoderWithKeyPathError.keyPathNotFound(KeyPath)
    }
}
