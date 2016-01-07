//
//  ViewController.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 10..
//  Copyright © 2015년 doozerstage. All rights reserved...
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
/*
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
        
        let things: [TextRepresentable] = [game, d12, simonTheHamster]
        
        for thing in things {
            
            print(thing.textualDescription)
        }
        
        print(game.prettyTextualDescription)

        let birthdayPerson = Person(name: "Malcolm", age: 21)
        
        wishHappyBirthday(birthdayPerson)

        
        let objects: [AnyObject] = [
            
            Circle(radius: 2.0),
            
            Country(area: 243_610),
            
            Animal(legs: 4)
        ]
        
        for object in objects {
            
            if let objectWithArea = object as? HasArea {
                
                print("Area is \(objectWithArea)")
                
            } else {
                
                print("Something that doesn't have an area")
            }
        }

        let counter = Counter()
        
        counter.dataSource = ThreeSource()
        
        for _ in 1...4 {
            
            counter.increment()
            
            print(counter.count)
        }

        counter.count = -4
        
        counter.dataSource = TowardZeroSource()
        
        for _ in 1...5 {
            
            counter.increment()
            
            print(counter.count)
        }

        
        let generator = LinearCongruentialGenterator()
        print("Here's a random number: \(generator.random())")
        print("And here's a random Boolean: \(generator.randomBool())")
        
        let murrayTheHamster = Hamster(name: "Murray")
        let morganTheHamster = Hamster(name: "Morgan")
        let mauriceTheHamster = Hamster(name: "Maurice")
        let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
        print(hamsters.textualDescription)
*/
        
        var someInt = 3
        
        var anotherInt = 107
        
        swapTwoInts(&someInt, &anotherInt)
        
        print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
        
    }
}




























