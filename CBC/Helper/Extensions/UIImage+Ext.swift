//
//  ImageView+Ext.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-03.
//

import Foundation
import UIKit

extension UIImage {
    func aspectFitSize(in boundingSize: CGSize) -> CGSize {
        let aspectWidth = boundingSize.width / size.width
        let aspectHeight = boundingSize.height / size.height

        let minAspect = min(aspectWidth, aspectHeight)
        return CGSize(width: size.width * minAspect, height: size.height * minAspect)
    }
}
