//
//  Weather.swift
//  LemonadeStand
//
//  Created by ARogan on 10/13/14.
//  Copyright (c) 2014 Bone Hammer Studios. All rights reserved.
//

import Foundation
import UIKit

class Weather {
    let coldImage = UIImage(named: "cold")
    let mildImage = UIImage(named: "mild")
    let warmImage = UIImage(named: "warm")
    
    let baseCustomerCount = 10
    let coldCustomerAdjust = -3
    let warmCustomerAdjust = 4
    
    var currentWeatherImage = UIImage()
    var currentWeatherName = ""
    var customerCount = 0
    
    init () {
        generateWeather()
    }
    
    func generateWeather() {
        var randomNumber = Int(arc4random_uniform(UInt32(3)))
        
        switch randomNumber {
        case 0:
            currentWeatherImage = coldImage
            currentWeatherName = "cold"
            customerCount = baseCustomerCount + coldCustomerAdjust
        case 1:
            currentWeatherImage = mildImage
            currentWeatherName = "mild"
            customerCount = baseCustomerCount
        case 2:
            currentWeatherImage = warmImage
            currentWeatherName = "warm"
            customerCount = baseCustomerCount + warmCustomerAdjust
        default:
            currentWeatherImage = coldImage
            currentWeatherName = "cold"
            customerCount = baseCustomerCount + coldCustomerAdjust
        }
        
        println("customer count = \(customerCount); weather = \(currentWeatherName)")
    }
}