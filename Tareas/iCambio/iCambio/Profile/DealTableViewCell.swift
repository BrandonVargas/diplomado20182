//
//  DealTableViewCell.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 26/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import CodableFirebase

class DealTableViewCell: UITableViewCell {

    @IBOutlet weak var userOwnerImageView: UIImageView!
    @IBOutlet weak var userOfferingImageView: UIImageView!
    @IBOutlet weak var labelOwner: UILabel!
    @IBOutlet weak var offeringStackView: UIStackView!
    @IBOutlet weak var dealImageView: UIImageView!
    
    let userRepository = UserRepository()
    let articlesRepository = ArticlesRepository()
    let disposeBag = DisposeBag()
    
    var item: Offer? {
        didSet {
            guard item != nil else {
                return
            }
            setupView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userOwnerImageView.layer.cornerRadius = userOwnerImageView.bounds.width/2
        userOwnerImageView.layer.masksToBounds = true
        userOfferingImageView.layer.cornerRadius = userOfferingImageView.bounds.width/2
        userOfferingImageView.layer.masksToBounds = true
        dealImageView.layer.cornerRadius = dealImageView.bounds.width/2
        dealImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        item!.userOwnerUID.getDocument(completion: { doc, error in
            let user = try! FirestoreDecoder().decode(User.self, from: doc!.data()!)
            let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
            self.userOwnerImageView.kf.setImage(with: resource)
        })
        
        item!.userOffering.getDocument(completion: { doc, error in
            let user = try! FirestoreDecoder().decode(User.self, from: doc!.data()!)
            let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
            self.userOfferingImageView.kf.setImage(with: resource)
        })
        
        item!.itemOwnerId.getDocument(completion: { doc, error in
            let article = try! FirestoreDecoder().decode(Article.self, from: doc!.data()!)
            self.labelOwner.text = article.name
        })
        
        for ref in (item?.itemsOfferingIds)! {
            ref.getDocument(completion: { doc, error in
                let article = try! FirestoreDecoder().decode(Article.self, from: doc!.data()!)
                let label = UILabel()
                label.font = UIFont(name: "Futura", size: 22)
                label.text = article.name
                self.offeringStackView.addArrangedSubview(label)
            })
        }
    }
    
}
