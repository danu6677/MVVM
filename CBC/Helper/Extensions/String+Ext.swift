//
//  String+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-02.
//

import Foundation

extension String {
    func loadDataFromURL(completion: @escaping (Data?) -> Void) {
        // Check if the string can be converted to a URL
        guard let url = URL(string: self) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle the error
                print("Error: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data {
                // Data loaded successfully
                completion(data)
            }
            
        }
        task.resume()
    }
    
}
