//
//  FilmDetailsTableViewCell.swift
//  GiftedTask
//
//  Created by zone on 8/21/21.
//

import UIKit

class FilmDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var directorNameLbl: UILabel!
    @IBOutlet weak var producerNameLbl: UILabel!
    @IBOutlet weak var releaseDataLbl: UILabel!
    @IBOutlet weak var openingCrawlLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
