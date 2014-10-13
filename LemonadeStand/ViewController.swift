//
//  ViewController.swift
//  LemonadeStand
//
//  Created by ARogan on 10/13/14.
//  Copyright (c) 2014 Bone Hammer Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var lemonLabel: UILabel!
    @IBOutlet weak var iceCubeLabel: UILabel!
    @IBOutlet weak var ratio: UILabel!
    
    @IBOutlet weak var lemonPriceLabel: UILabel!
    @IBOutlet weak var iceCubePriceLabel: UILabel!
    @IBOutlet weak var buyLemonLabel: UILabel!
    @IBOutlet weak var buyIceCubeLabel: UILabel!
    
    @IBOutlet weak var mixLemonLabel: UILabel!
    @IBOutlet weak var mixIceCubeLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    var supplies = Supplies(aMoney: 10, aLemons: 0, aIce: 0)
    let prices = Prices()
    let weather = Weather()
    var simEngine: SimulationEngine = SimulationEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       simEngine = SimulationEngine(aPrices: prices, aSupplies: supplies, aWeather: weather)
       refreshAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshInventoryDisplay() {
        moneyLabel.text = "$\(supplies.money)"
        lemonLabel.text = "\(supplies.lemons) Lemons"
        iceCubeLabel.text = "\(supplies.ice) Ice Cubes"
        
    }
    
    func refreshPurchaseDisplay() {
        lemonPriceLabel.text = "Lemons for $\(prices.lemons)"
        iceCubePriceLabel.text = "Ice Cubes for $\(prices.ice)"
        buyLemonLabel.text = "\(supplies.lemonsBought)"
        buyIceCubeLabel.text = "\(supplies.iceBought)"
    }
    
    func refreshMixDisplay() {
        mixLemonLabel.text = "\(supplies.lemonsMix)"
        mixIceCubeLabel.text = "\(supplies.iceMix)"
        ratio.text = "\(supplies.getRatio())"
    }
    
    func refreshAll() {
        refreshInventoryDisplay()
        refreshPurchaseDisplay()
        refreshMixDisplay()
        weatherImage.image = weather.currentWeatherImage
    }
    
    func showAlertWithText(header:String = "Warning", message:String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func buyLemon(sender: UIButton) {
        if !supplies.buyLemon(prices) {
            showAlertWithText(message: "You don't have enough money.")
        }
        else {
            refreshAll()
        }
    }

    @IBAction func sellLemon(sender: UIButton) {
        if !supplies.sellLemon(prices) {
            showAlertWithText(message: "You don't have any lemons to sell.")
        }
        else {
            refreshAll()
        }
    }
    
    @IBAction func buyIce(sender: UIButton) {
        if !supplies.buyIce(prices) {
            showAlertWithText(message: "You don't have enough money.")
        }
        else {
         refreshAll()        }
    }
    
    @IBAction func sellIce(sender: UIButton) {
        if !supplies.sellIce(prices) {
            showAlertWithText(message: "You don't have any ice cubes to sell.")
        }
        else {
           refreshAll()        }
    }
    
    @IBAction func addLemon(sender: UIButton) {
        if !supplies.addLemon() {
            showAlertWithText(message: "You don't have anymore lemons to add.")
        }
        else {
           refreshAll()
        }
    }
    
    @IBAction func removeLemon(sender: UIButton) {
        supplies.removeLemon()
        refreshAll()
    }
    
    @IBAction func addIce(sender: UIButton) {
        if !supplies.addIce() {
            showAlertWithText(message: "You don't have anymore ice cubes to add.")
        }
        else {
         refreshAll()
        }
    }
    
    @IBAction func removeIce(sender: UIButton) {
        supplies.removeIce()
        refreshAll()
    }
    
    @IBAction func startDay(sender: UIButton) {
        var simResults = simEngine.startDay()
        showAlertWithText(header: "Results", message: simResults.details)
        if simResults.isGameOver {
            supplies.resetAll()
        }
        refreshAll()
    }
    
    
}

