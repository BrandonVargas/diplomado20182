//
//  OfferTableViewCell.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 22/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class OfferTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var articlesStackView: ArticlesStackView!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var iCambioButton: UIButton!
    
    var declineClosure: (() -> Void)?
    var iCambioClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView() {
        articlesStackView.spacing = 8
    }

    @IBAction func declineOfferClicked(_ sender: UIButton) {
        declineClosure?()
    }
    
    @IBAction func iCambioClicked(_ sender: UIButton) {
        iCambioClosure?()
    }
    
}
