//
//  NewsCollectionViewCell.swift
//  CBC
//
//  Created by Danutha Fernando on 2023-10-01.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var customeVw: UIView!
    
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var publishedDateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static var nib: UINib {
            return UINib(nibName: String(describing: self), bundle: nil)
    }
}
