//
//  ViewController.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 10..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        let tracker = DiceGameTracker()
        
        let game = SnakeAndLadders()
        
        game.delegate = tracker
        
        game.play()
        
        let d12 = Dice(sides: 12, generator: LinearCongruentialGenterator())
        
        print(d12.textualDescription)
        
        print(game.textualDescription)
        
        let simonTheHamster = Hamster(name: "Simon")
        
        let somethingTextRepresentable: TextRepresentable = simonTheHamster
        
        print(somethingTextRepresentable.textualDescription)
    }
}


