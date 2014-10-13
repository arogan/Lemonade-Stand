//
//  Supplies.swift
//  LemonadeStand
//
//  Created by ARogan on 10/13/14.
//  Copyright (c) 2014 Bone Hammer Studios. All rights reserved.
//

import Foundation

class Supplies {
    var money = 10
    var lemons = 0
    var ice = 0
    
    var lemonsBought = 0
    var iceBought = 0
    var lemonsMix = 0
    var iceMix = 0
    
    init (aMoney: Int, aLemons: Int, aIce: Int) {
        money = aMoney
        lemons = aLemons
        ice = aIce
        
        lemonsBought = 0
        iceBought = 0
        lemonsMix = 0
        iceMix = 0
    }
    
    func buyLemon (prices: Prices) -> Bool {
        if money < prices.lemons {
            return false
        }
        
        lemonsBought++
        lemons++
        money -= prices.lemons
        
        return true
    }
    
    func sellLemon (prices: Prices) -> Bool {
        if lemons < 1 {
            return false
        }
        
        lemons--
        money += prices.lemons
        if lemonsBought > 0 {
            lemonsBought--
        }
        
        if lemonsMix > lemons {
            lemonsMix = lemons
        }
        
        return true
    }
    
    func buyIce (prices: Prices) -> Bool {
        if money < prices.ice {
            return false
        }
        
        iceBought++
        ice++
        money -= prices.ice
        
        return true
    }
    
    func sellIce (prices: Prices) -> Bool {
        if ice < 1 {
            return false
        }
        
        ice--
        money += prices.ice
        if (iceBought > 0) {
            iceBought--
        }
        
        if iceMix > ice {
            iceMix = ice
        }
        
        return true
    }
    
    func addLemon() -> Bool {
        if lemonsMix >= lemons {
            return false
        }
        lemonsMix++
        return true
    }
    
    func removeLemon() {
        if lemonsMix > 0 {
            lemonsMix--
        }
    }
    
    func addIce() -> Bool {
        if iceMix >= ice {
            return false
        }
        iceMix++
        return true
    }
    
    func removeIce() {
        if iceMix > 0 {
            iceMix--
        }
    }
    
    func getRatio() -> Double {
        if iceMix == 0 {
            if lemonsMix >= 1 {
                return 1
            }
            else {
                return 0
            }
        }
        var ret = Double(lemonsMix) / Double(iceMix)
        if ret > 1.0 {
            ret = 1.0
        }
        
        return ret
    }
    
    func resetBuyAndMix() {
        lemonsBought = 0
        iceBought = 0
        lemonsMix = 0
        iceMix = 0
    }
    
    func resetAll() {
        resetBuyAndMix()
        lemons = 0
        ice = 0
        money = 10
    }    
}