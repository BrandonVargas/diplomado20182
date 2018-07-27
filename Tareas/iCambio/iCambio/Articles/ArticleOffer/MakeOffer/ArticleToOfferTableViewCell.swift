//
//  ArticleToOfferTableViewCell.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 27/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ArticleToOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedSwitch: UIImageView!
    @IBOutlet weak var articleNameLabel: UILabel!
    @IBOutlet weak var articleOffersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedSwitch.image = UIImage(named: "switchOff")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedSwitch.image = UIImage(named: "switchOn")
            self.contentView.backgroundColor = UIColor.init(named: "PastelRed")
        } else {
            selectedSwitch.image = UIImage(named: "switchOff")
            self.contentView.backgroundColor = UIColor.init(named: "MintCream")
        }
        // Configure the view for the selected state
    }

}
