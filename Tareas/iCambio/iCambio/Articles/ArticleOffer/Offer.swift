//
//  Offer.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 29/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

struct Offer: Codable {
    var id: String
    var status: Int
    var userOfferingUID: String
    var userOwnerUID: String
    var itemOwnerId: String
    var itemsOfferingIds: [String]
}

enum OfferStates: Int, Codable{
    case PENDING = 0
    case DECLINED = 1
    case SUCCESSFUL = 2
}
