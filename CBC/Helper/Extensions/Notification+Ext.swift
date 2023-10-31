//
//  Notification+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
//NetworkMonitor Notifications
extension Notification.Name {
    static let NetworkConnected = NSNotification.Name("NetworkConnected")
    static let NetworkDisconnected = NSNotification.Name("NetworkDisconnected")
    static let NetworkChanged = NSNotification.Name("NetworkChanged")
}
