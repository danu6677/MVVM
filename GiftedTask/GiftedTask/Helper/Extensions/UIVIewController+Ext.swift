//
//  UIVIewController.swift
//  GiftedTask
//
//  Created by zone on 8/21/21.
//


import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true)
  }
}
