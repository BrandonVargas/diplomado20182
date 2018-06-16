//
//  User.swift
//  iCambio
//
//  Created by José Brandon Vargas Mariñelarena on 14/04/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import Foundation

struct User: Codable {
    var UID: String
    var name: String
    var email: String
    var imageURL: String
    var rating: Rating?
    var comments: Array<Comment>?
    var settings: Settings?
    var location: Geopoint?
}

struct Geopoint: Codable {
    var latitude: Double
    var longitude: Double
}

struct Rating: Codable {
    var rating: Double
    var ratingTimes: Int
    var tradesQuantity: Int
}

struct Comment: Codable {
    var UID: String
    var content: String
}

struct Settings: Codable {
    var geofenceKm: Double
}
