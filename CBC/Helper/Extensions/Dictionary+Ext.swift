//
//  Dictionary+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
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
