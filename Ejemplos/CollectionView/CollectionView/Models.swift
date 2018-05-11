//
//  Models.swift
//  CollectionView
//
//  Created by José Brandon Vargas Mariñelarena on 21/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class Category: NSObject {
    var name: String?
    var albums:[Album]?
    
    static func samples() -> [Category] {
        let bestNewAlbums = Category()
        bestNewAlbums.name = "Los Mejores"
        
        return [bestNewAlbums]
    }
}

class Album: NSObject {
    var name: String?
    var category: String?
    var image: String?
}
