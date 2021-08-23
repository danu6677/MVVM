//
//  TableViewCell+Ext.swift
//  GiftedTask
//
//  Created by zone on 8/22/21.
//

import Foundation
import UIKit

extension UITableViewCell {
  func separator(hide: Bool) {
    separatorInset.left = hide ? bounds.size.width : 0
  }
}
