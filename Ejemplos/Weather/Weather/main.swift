//
//  main.swift
//  Weather
//
//  Created by José Brandon Vargas Mariñelarena on 03/03/18.
//  Copyright © 2018 José Brandon Vargas Mariñelarena. All rights reserved.
//

import UIKit
UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv)
                    .bindMemory(
                        to: UnsafeMutablePointer<Int8>.self,
                        capacity: Int(CommandLine.argc)),
                  NSStringFromClass(WeatherApplication.self),
                  NSStringFromClass(AppDelegate.self)
)
