//
//  String+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-02.
//

import Foundation

extension String {
    
    func synchronousLoadDataFromURL(timeout: TimeInterval = 10.0) -> Data? {
        guard let url = URL(string: self) else {
            return nil
        }
        
        var resultData: Data?
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { semaphore.signal() }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                resultData = data
            }
        }.resume()
        
        let _ = semaphore.wait(timeout: .now() + timeout)
        return resultData
    }
    
}
