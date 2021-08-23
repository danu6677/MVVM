//
//  UIVIew+Ext.swift
//  GiftedTask
//
//  Created by zone on 8/19/21.
//

import Foundation
import UIKit

extension UIView{
    //Custom Loader
 fileprivate func customActivityIndicator(view: UIView, widthView: CGFloat?,backgroundColor: UIColor?, textColor:UIColor?, message: String?) -> UIView{

    //Config UIView
    self.backgroundColor = backgroundColor //Background color of the loaders view

    var selfWidth = view.frame.width
    if widthView != nil{
        selfWidth = widthView ?? selfWidth
    }

    let selfHeigh = view.frame.height
    let loopImages = UIImageView()

    var imageListArray = [UIImage]() // Array of images in a specific order to load the animation.
    for i in 1...9 {
        imageListArray.append(UIImage(named: "\(i)")!)
    }
    loopImages.animationImages = imageListArray
    loopImages.animationDuration = TimeInterval(2.0)
    loopImages.startAnimating()

    let imageFrameX = CGFloat(0.0)
    let imageFrameY = CGFloat(0.0)
    var imageWidth = CGFloat(selfWidth)
    var imageHeight = CGFloat(selfHeigh)

    if widthView != nil{
        imageWidth = widthView ?? imageWidth
        imageHeight = widthView ?? imageHeight
    }

    //ConfigureLabel
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 17) // Your Desired UIFont Style and Size
    label.numberOfLines = 0
    label.text = message ?? ""
    label.textColor = textColor ?? UIColor.clear

    //Config frame of label
    let labelFrameX = (selfWidth / 2) - 100
    let labelFrameY = CGFloat(100.0)
    let labelWidth = CGFloat(200)
    let labelHeight = CGFloat(70)

    // Define UIView frame
    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height)


    //ImageFrame
    loopImages.frame = CGRect(x: imageFrameX, y: imageFrameY, width: imageWidth, height: imageHeight)

    //LabelFrame
    label.frame = CGRect(x: labelFrameX, y: labelFrameY, width: labelWidth, height: labelHeight)

    //add loading and label to customView
    self.addSubview(loopImages)
    self.addSubview(label)
    return self
    
  }
    
    func showLoader(_ reconnect:Bool? = nil) {
        var message : String {
            get {
                return reconnect ?? false ? "Please bare \nThe Connectivity Changed..." : "Please bare \nData is Syncing..."
            }
        }
            self.addSubview(UIView().customActivityIndicator(view: self, widthView: nil, backgroundColor:.white, textColor: .white, message: message))
    
    }
    
    func hideLoader(){
            self.subviews.last?.removeFromSuperview()
    }
}

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
