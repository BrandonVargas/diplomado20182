//
//  AlbumCell.swift
//  CollectionView
//
//  Created by José Brandon Vargas Mariñelarena on 21/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        iv.image = UIImage(named: "cover2")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = (iv.image?.size.width)!/2
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ALV"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        addSubview(imageView)
        addSubview(titleLabel)
        //addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView, "v1": titleLabel]))
    }
    
}
