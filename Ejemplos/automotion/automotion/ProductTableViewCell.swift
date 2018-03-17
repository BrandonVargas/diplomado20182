//
//  ProductTableViewCell.swift
//  automotion
//
//  Created by José Brandon Vargas Mariñelarena on 16/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dealsNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
