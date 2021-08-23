//
//  Common+Ext.swift
//  GiftedTask
//
//  Created by zone on 8/17/21.
//

import Foundation
/****No Other classes imported other than the Base Foundation class provided****/

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

//Converts a dictionary in to a queryString
extension Dictionary {
    var queryString: Data {

       var string: String = ""
       for (key, value) in self {
           string +=  "\(key)=\(value)&"
       }
        string = String(string.dropLast())
        let data = NSMutableData(data: string .data(using: String.Encoding.utf8)!)

       return data as Data
    }
    
 }
//Sum of elements in any Collection
extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}
//NetworkMonitor Notifications
extension Notification.Name {
    static let NetworkConnected = NSNotification.Name("NetworkConnected")
    static let NetworkDisconnected = NSNotification.Name("NetworkDisconnected")
    static let NetworkChanged = NSNotification.Name("NetworkChanged")
}

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}
