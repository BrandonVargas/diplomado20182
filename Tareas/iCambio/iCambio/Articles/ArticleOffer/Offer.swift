//
//  Offer.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 29/06/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation
import Firebase

struct Offer: Codable {
    var id: String
    var status: Int
    var userOffering: DocumentReference
    var userOwnerUID: DocumentReference
    var itemOwnerId: DocumentReference
    var itemsOfferingIds: [DocumentReference]
}

enum OfferStates: Int, Codable{
    case PENDING = 0
    case DECLINED = 1
    case SUCCESSFUL = 2
}
