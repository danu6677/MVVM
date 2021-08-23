//
//  ConnectivityManager.swift
//  GiftedTask
//
//  Created by zone on 8/18/21.
//

import Foundation
import Network

class ConnectivityManager {
    // Singleton
    public static let shared =  ConnectivityManager()

    private let monitor: NWPathMonitor =  NWPathMonitor(requiredInterfaceType: .wifi)
    private (set) var wifiAccess: Bool = false
     
    private var isRunningOnSimulator: Bool{
        get {
            #if targetEnvironment(simulator)
              return true
            #else
              return false
            #endif
        }
    }
    private init() {
       
        
        monitor.pathUpdateHandler = {[weak self] path in
            
            if (path.status == .satisfied) {
                self?.wifiAccess = true
                NotificationCenter.default.post(name: .NetworkConnected, object: path.isExpensive)
            }else if (path.status == .unsatisfied) && ((self?.isRunningOnSimulator) != nil){
                NotificationCenter.default.post(name: .NetworkChanged, object: path.isExpensive)
                do {
                      /*Delay untill the network forms a strong connection (completely Online or Offline). Otherwise the state becomes inconsistant*/
                       sleep(4)
                       self?.checkApiAccess { (reachable) in
                        self?.wifiAccess = reachable
                        let type:Notification.Name = reachable ? .NetworkConnected : .NetworkDisconnected
                        NotificationCenter.default.post(name: type, object: path.isExpensive)
                    }
                }
            }else {
                NotificationCenter.default.post(name: .NetworkDisconnected, object: path.isExpensive)
            }
        }
    }
    
    func start() {
        // Start monitoring
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    func checkApiAccess(completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: Config.BASE_URL) else { return }

        var request = URLRequest(url: url)
        request.timeoutInterval = 20.0
        request.allowsCellularAccess = true
        request.allowsConstrainedNetworkAccess = true
        request.allowsExpensiveNetworkAccess = true

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(false)
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 200) {
                    completion(true)
                }
            }
        }
        task.resume()
    }
}




