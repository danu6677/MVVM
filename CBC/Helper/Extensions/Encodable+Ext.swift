//
//  Encodable.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
//Converts a struct in to a dictionary
struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
