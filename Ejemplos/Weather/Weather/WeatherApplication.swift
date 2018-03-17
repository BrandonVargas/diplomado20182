//
//  WeatherApplication.swift
//  Weather
//
//  Created by José Brandon Vargas Mariñelarena on 03/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit

class WeatherApplication: UIApplication {
    
    override func sendEvent(_ event: UIEvent) {
        print("Event \(event.type.rawValue)")
        print("Event \(event.type.rawValue)")
        super.sendEvent(event)
    }
    
}
