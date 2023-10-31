//
//  UiView+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import UIKit
@IBDesignable class CardView: UIView {
    var conerRadius: CGFloat = 10
    var offsetWidth: CGFloat = 5
    var offsetHeight: CGFloat = 5
    
    var offsetShadowOpacity: Float = 5
    var color = UIColor.gray
    
    
    override func layoutSubviews() {
        layer.cornerRadius = conerRadius
        layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.conerRadius).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = self.offsetShadowOpacity
    }
    
    
}
