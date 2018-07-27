//
//  Article.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 05/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

struct Article: Codable {
    var id: String
    var userUID: String
    var name: String
    var pictures: Array<String>
    var description: String
    var available: Bool
}
