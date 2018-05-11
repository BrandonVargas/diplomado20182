//
//  CategoryCell.swift
//  CollectionView
//
//  Created by José Brandon Vargas Mariñelarena on 21/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let albumCellId = "albumCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let albumCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Los más vergas"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        self.addSubview(categoryLabel)
        self.addSubview(albumCollectionView)
        albumCollectionView.register(AlbumCell.self, forCellWithReuseIdentifier: albumCellId)
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1]-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": albumCollectionView, "v1": categoryLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1": categoryLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": albumCollectionView]))
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumCellId, for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: frame.height, height: frame.height)
    }
}
