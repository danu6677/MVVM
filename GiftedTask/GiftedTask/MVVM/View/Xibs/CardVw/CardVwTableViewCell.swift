//
//  CardVwTableViewCell.swift
//  GiftedTask
//
//  Created by zone on 8/22/21.
//

import UIKit

class CardVwTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
