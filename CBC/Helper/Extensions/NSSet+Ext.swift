//
//  NSSet.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}
