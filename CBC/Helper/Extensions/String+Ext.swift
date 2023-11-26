//
//  String+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-02.
//

import Foundation

extension String {
    //Download image synchronously
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
    
    //Download image Asynchronously with completion handler
    func asyncDownloadFromUrlString(completion: @escaping (Data)->Void) {
        if let url = URL(string: self) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    completion(data)
                }
                
            }
            task.resume()
        }
        
    }
    //Download image Asynchronously with Aync Await 
    func fetchDataFromUrlString() async throws -> Data {
        guard let url = URL(string: self) else {
            throw ImageDownloadError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw ImageDownloadError.downloadFailed
        }
    }

}
enum ImageDownloadError: Error {
    case invalidURL
    case downloadFailed
}
