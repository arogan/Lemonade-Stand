//
//  SimulationEngine.swift
//  LemonadeStand
//
//  Created by ARogan on 10/13/14.
//  Copyright (c) 2014 Bone Hammer Studios. All rights reserved.
//

import Foundation
import UIKit

struct Range {
    var min: Double = 0.0
    var max: Double = 0.0
}

struct Customer {
    var bias: Double = 0.0
    var rangeIndex = 0
}

class SimulationEngine {
    var prices: Prices!
    var supplies: Supplies!
    var weather: Weather!
    
    var customers: [Customer] = []
    var ranges:[Range] = []
    
    init() {
        
    }
    
    init (aPrices: Prices, aSupplies: Supplies, aWeather: Weather) {
        prices = aPrices
        supplies = aSupplies
        weather = aWeather
        setRanges()
    }
    
    func setRanges() {
        var range = Range(min: 0.0, max: 0.4)
        ranges.append(range)
        range = Range(min: 0.4, max: 0.6)
        ranges.append(range)
        range = Range(min: 0.6, max: 1.0)
        ranges.append(range)
    }
    
    func generateCustomers() {
        customers.removeAll(keepCapacity: false)
        for var index = 0; index < weather.customerCount; ++index {
            var randomNumber = Int(arc4random_uniform(UInt32(10))) + 1
            var cbias:Double = Double(randomNumber) / 10.0
            var rangeIndex = 0
            for range in ranges {
                if cbias >= range.min && cbias <= range.max {
                    var customer = Customer(bias: cbias, rangeIndex: rangeIndex)
                    customers.append(customer)
                    break
                }
                rangeIndex++
            }
        }
    }
    
    func startDay() -> (isGameOver: Bool, details: String) {
        var ratio = supplies.getRatio()
        var cPayout = 0;
        var ratioRangeIndex = 0
        var cDetails = ""
        var ratioRange: Range = Range()
        var customerIndex = 0
        var soldCount = 0
        var cIsGameOver = false
        
        if (supplies.lemons == 0 && supplies.ice == 0) {
            return (cIsGameOver, "You have no supplies")
        }
        
        if (supplies.lemonsMix == 0 && supplies.iceMix == 0) {
            return (cIsGameOver, "You haven't mixed any ingredients")
        }
        
        if (supplies.lemonsMix == 0) {
            return (cIsGameOver, "You must have at least 1 lemon in your mix.")
        }
        
        if (supplies.iceMix == 0) {
            return (cIsGameOver, "You must have at least 1 ice cube in your mix.")
        }
        
        weather.generateWeather()
        self.generateCustomers()
        
        //get range for current mix ratio
        for range in ranges {
            if ratio >= range.min && ratio <= range.max {
                ratioRange = range
                break
            }
            ratioRangeIndex++
        }
        
        cDetails += "Current weather: \(weather.currentWeatherName) \r\n"
        cDetails += "Total customers today: \(customers.count)\r\n"
        cDetails += "Current mix ratio = \(ratio) which puts us in ratioRangeIndex = \(ratioRangeIndex). Range = \(ratioRange.min) - \(ratioRange.max). \r\n\r\n"
        
        for customer in customers {
            cDetails += "Customer [\(customerIndex)] bias = \(customer.bias): "
            if customer.rangeIndex == ratioRangeIndex {
                cPayout += prices.sellPrice
                cDetails += "Sale!\r\n"
                soldCount++
            }
            else {
                cDetails += "No Sale\r\n"
            }
            customerIndex++
        }
        
        cDetails += "\r\n\r\nYou made: $\(cPayout)"
        supplies.money += cPayout
        supplies.lemons -= supplies.lemonsMix
        supplies.ice -= supplies.iceMix
        supplies.resetBuyAndMix()
        
        //check for game over condition
        let minMoney = prices.lemons + prices.ice
        println("minMoney = \(minMoney); money = \(supplies.money)")
        if supplies.money < minMoney {
            if supplies.lemons == 0 && supplies.money < prices.lemons {
                //can't buy any more lemons so game over
                cIsGameOver = true
            }
            else if supplies.ice == 0 && supplies.money < prices.ice {
                //can't buy anymore ice so game over
                cIsGameOver = true
            }
            else if supplies.lemons == 0 && supplies.lemons == 0 {
                //need to buy both but can't afford both ingredients
                cIsGameOver = true
            }
            if cIsGameOver {
                cDetails += "\r\n\r\nGAME OVER: You are out of money and supplies.  Resetting game...."
            }
        }
        
        return (cIsGameOver, cDetails)
    }
    
}