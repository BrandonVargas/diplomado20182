//
//  ArticleTableViewCell.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 07/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    let articleImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.init(named: "no_image")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let userImage: UIImageView = {
        let img = UIImageView()
        img.layer.borderWidth = 1
        img.layer.masksToBounds = false
        img.layer.cornerRadius = img.frame.height/2
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let articleName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let articlePrice: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let userName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let offers: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 150)
            ])
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupLayout() {
        self.addSubview(articleImage)
        NSLayoutConstraint.activate([
            articleImage.topAnchor.constraint(equalTo: self.topAnchor),
            articleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            articleImage.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        self.addSubview(articleName)
        NSLayoutConstraint.activate([
            articleName.topAnchor.constraint(equalTo: self.topAnchor),
            articleName.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        
        self.addSubview(articlePrice)
        NSLayoutConstraint.activate([
            articlePrice.topAnchor.constraint(equalTo: articleImage.bottomAnchor),
            articlePrice.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        
        self.addSubview(offers)
        NSLayoutConstraint.activate([
            offers.topAnchor.constraint(equalTo: articlePrice.bottomAnchor),
            offers.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            offers.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        
        self.addSubview(userImage)
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: articleImage.bottomAnchor),
            userImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
        self.addSubview(userName)
        NSLayoutConstraint.activate([
            offers.topAnchor.constraint(equalTo: articlePrice.bottomAnchor),
            offers.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            offers.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
