//
//  ConectivityManager.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import Foundation
import Network

final class NetworkMonitor {

    static let shared = NetworkMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    let monitor = NWPathMonitor()
    public private(set) var isConnected: Bool = false
    private var hasStatus: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            #if targetEnvironment(simulator)
                if (!self.hasStatus) {
                    self.isConnected = path.status == .satisfied
                    self.hasStatus = true
                } else {
                    self.isConnected = !self.isConnected
                }
            #else
                self.isConnected = path.status == .satisfied
            #endif
           // print("isConnected: " + String(self.isConnected))
            let name : NSNotification.Name = self.isConnected ? .NetworkConnected : .NetworkDisconnected
            NotificationCenter.default.post(name: name, object: path.isExpensive)
        }
        monitor.start(queue: queue)
    }

}
