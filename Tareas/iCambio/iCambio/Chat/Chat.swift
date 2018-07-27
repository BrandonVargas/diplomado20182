//
//  Chat.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 25/07/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

struct Chat: Codable {
    var id: String
    var offerId: String
}

struct Message: Codable {
    var message: String
    var senderId: String
}
