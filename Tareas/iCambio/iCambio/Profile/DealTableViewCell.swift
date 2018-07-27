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
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        
        UserRepository().getUserImageWith(uid: (item!.userOwnerUID))
            .subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                    let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
                    self.userOwnerImageView.kf.setImage(with: resource)
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: self.disposeBag)
        UserRepository().getUserImageWith(uid: (item!.userOfferingUID))
            .subscribe(onNext: { documents in
                if let document = documents.documents.first {
                    print("Document data: \(document.data())")
                    let user = try! FirestoreDecoder().decode(User.self, from: document.data())
                    let resource = ImageResource(downloadURL: URL(string: user.imageURL)!, cacheKey: user.imageURL)
                    self.userOfferingImageView.kf.setImage(with: resource)
                }
            }, onError: { error in
                print("Hubo un error \(error)")
            }).disposed(by: self.disposeBag)
        articlesRepository.getArticleName(id: (item?.itemOwnerId)!)
            .subscribe(onNext: { name in
                self.labelOwner.text = name
            }).disposed(by: self.disposeBag)
        var labelObservables = [Observable<String>]()
        for id in (item!.itemsOfferingIds) {
            labelObservables.append(articlesRepository.getArticleName(id: id))
        }
        Observable.zip(labelObservables).subscribe(onNext: { names in
            for name in names {
                let label = UILabel()
                label.font = UIFont(name: "Futura", size: 22)
                label.text = name
                self.offeringStackView.addArrangedSubview(label)
            }
        }).disposed(by: self.disposeBag)
    }
    
}
