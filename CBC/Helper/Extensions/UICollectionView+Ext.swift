//
//  UICollectionView+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-09-30.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: AlertAction.OK, style: .default))
    self.present(alert, animated: true)
  }
 
  func showAlertWithActions(title: String, message: String, yesAction: (() -> Void)? = nil, noAction: (() -> Void)? = nil) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            // "Yes" action
      let yesButton = UIAlertAction(title: AlertAction.RELOAD, style: .default) { (_) in
                yesAction?() // Execute the "Yes" action if provided
            }
            
            // "No" action
      let noButton = UIAlertAction(title: AlertAction.NO, style: .destructive) { (_) in
                noAction?() // Execute the "No" action if provided
            }
            
            alert.addAction(yesButton)
            alert.addAction(noButton)
            
            self.present(alert, animated: true)
    }
    
}
