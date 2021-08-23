//
//  Utils.swift
//  GiftedTask
//
//  Created by zone on 8/20/21.
//

import Foundation

class Utils {
 
    class func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    
    class func loadImage(url: String,completion:@escaping (Data)->Void) {
      DispatchQueue.global().async {
        let url = URL(string: url)
        if let data = try? Data(contentsOf: url!) {
            completion(data)
        }
      }
    }
}
