//
//  STDProtocol.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 5..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

import Foundation

protocol RandomNumberGenerator {
    
    func random() -> Double
}

class LinearCongruentialGenterator: RandomNumberGenerator {
    
    var lastRandom = 42.0
    
    let m = 139968.0
    
    let a = 3877.0
    
    let c = 29573.0
    
    func random() -> Double {
        
        lastRandom = ((lastRandom * a + c) % m)
        
        return lastRandom / m
    }
}

protocol Toggleable {
    
    mutating func toggle()
}

enum OnOffSwitch: Toggleable {
    
    case Off, On
    
    mutating func toggle() {
        
        switch self {
            
        case Off:
            
            self = On
            
        case On:
            
            self = Off
        }
    }
}

protocol DiceGame {
    
    var dice: Dice { get }
    
    func play()
}

protocol DiceGameDelegate {
    
    func gameDidStart(game: DiceGame)
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    
    func gameDidEnd(game: DiceGame)
}

class SnakeAndLadders: DiceGame {
    
    let finalSquare = 25
    
    let dice = Dice(sides: 6, generator: LinearCongruentialGenterator())
    
    var square = 0
    
    var board: [Int]
    
    init() {
        
        board = [Int](count: finalSquare + 1, repeatedValue: 0)
        
        board[03] = +08
        board[06] = +11
        board[09] = +09
        board[10] = +02
        board[14] = -10
        board[19] = -11
        board[22] = -02
        board[24] = -08
    }
    
    var delegate: DiceGameDelegate?
    
    func play() {
        
        square = 0
        
        delegate?.gameDidStart(self)
        
        gameLoop: while square != finalSquare {
            
            let diceRoll = dice.roll()
            
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            
            switch square + diceRoll {
                
            case finalSquare:
                
                break gameLoop
                
            case let newSquare where newSquare > finalSquare:
                
                continue gameLoop
                
            default:
                
                square += diceRoll
                
                square += board[square]
            }
        }
        
        delegate?.gameDidEnd(self)
    }
}

class Dice {
    
    let sides: Int
    
    let generator: RandomNumberGenerator
    
    init(sides: Int, generator: RandomNumberGenerator) {
        
        self.sides = sides
        
        self.generator = generator
    }
    
    func roll() -> Int {
        
        return Int(generator.random() * Double(sides)) + 1
    }
}

class DiceGameTracker: DiceGameDelegate {
    
    var numberOfTurns = 0
    
    func gameDidStart(game: DiceGame) {
        
        numberOfTurns = 0
        
        if game is SnakeAndLadders {
            
            print("Started a new game of Snakes and Ladders")
        }
        
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        
        ++numberOfTurns
        
        print("Rolled a \(diceRoll)")
    }
    
    func gameDidEnd(game: DiceGame) {
        
        print("The game lasted for \(numberOfTurns) turns")
    }
}

protocol TextRepresentable {
    
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    
    var textualDescription: String {
        
        return "A \(sides)-sided diec"
    }
}

extension SnakeAndLadders: TextRepresentable {
    
    var textualDescription: String {
        
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

struct Hamster {
    
    var name: String
    
    var textualDescription: String {
        
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentable {}

protocol PrettyTextRepresentable: TextRepresentable {
    
    var prettyTextualDescription: String { get }
}

extension SnakeAndLadders: PrettyTextRepresentable {
    
    var prettyTextualDescription: String {
        
        var output = textualDescription + ":\n"
        
        for index in 1...finalSquare {
            
            switch board[index] {
                
            case let ladder where ladder > 0:
                
                output += "▲ "
                
            case let snake where snake < 0:
                
                output += "▼ "
                
            default:
                
                output += "○ "
            }
        }
        
        return output
    }
}

protocol Named {
    
    var name: String { get }
    
}

protocol Aged {
    
    var age: Int { get }
}

struct Person: Named, Aged {
    
    var name: String
    
    var age: Int
}

func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    
    print("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}

protocol HasArea {
    
    var area: Double { get }
}

class Circle: HasArea {
    
    let pi = 3.1415927
    
    var radius: Double
    
    var area: Double {
        
        return pi * radius * radius
    }
    
    init(radius: Double) {
        
        self.radius = radius
    }
}

class Country: HasArea {
    
    var area: Double
    
    init(area: Double) { self.area = area }
}

class Animal {
    
    var legs: Int
    
    init(legs: Int) {
        
        self.legs = legs
        
    }
}

@objc protocol CounterDataSource {
    
    optional func incrementForCount(count: Int) -> Int
    
    optional var fixedIncrement: Int { get }
}

class Counter {
    
    var count = 0
    
    var dataSource: CounterDataSource?
    
    func increment() {
        
        if let amount = dataSource?.incrementForCount?(count) {
            
            count += amount
            
        } else if let amount = dataSource?.fixedIncrement {
            
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    
    let fixedIncrement = 3
}

@objc class TowardZeroSource: NSObject, CounterDataSource {
    
    func incrementForCount(count: Int) -> Int {
        
        if count == 0 {
            
            return 0
            
        } else if count < 0 {
            
            return 1
            
        } else {
            
            return -1
        }
    }
}

extension RandomNumberGenerator {
    
    func randomBool() -> Bool {
        
        return random() > 0.5
    }
}

extension PrettyTextRepresentable {
    
    var prettyTextualDescription: String {
        
        return textualDescription
    }
}

extension CollectionType where Generator.Element: TextRepresentable {
    
    var textualDescription: String {
        
        let itemsAsText = self.map {
            $0.textualDescription
        }
        
        return "[" + itemsAsText.joinWithSeparator(", ") + "]"
    }
}































































