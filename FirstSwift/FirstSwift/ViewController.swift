//
//  ViewController.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 10..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

import UIKit

enum VendingMachineError: ErrorType {
    
    case InvalidSelection
    
    case InsufficientFounds(coinsNeyeded: Int)
    
    case OutOfStock
}

struct BlackjackCard {
    
    enum Suit: Character {
        
        case Spades = "♠", Heart = "♡", Diamonds = "♢", Clubs = "♣"
    }
    
    enum Rank: Int {
        
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        
        case Jack, Queen, King, Ace
        
        struct Values {
            
            let first: Int, second: Int?
        }
        
        var values: Values {
            
            switch self {
                
            case .Ace:
                return Values(first: 1, second: 11)
                
            case .Jack, .Queen, .King:
                return Values(first: 10, second: nil)
                
            default:
                return Values(first: self.rawValue, second: nil)
                
            }
        }
    }
    
    let rank: Rank, suit: Suit
    
    var description: String {
        
        var output = "suit is \(suit.rawValue),"
        
        output += " value is \(rank.values.first)"
        
        if let second = rank.values.second {
            
            output += " or \(second)"
        }
        
        return output
    }
}

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        let theAceOfSpades = BlackjackCard(rank: .Ace, suit: .Spades)
        
        print("theAceOfSpades : \(theAceOfSpades.description)")
        
        let heartSymbol = BlackjackCard.Suit.Heart.rawValue
        
        print("heartSymbol : \(heartSymbol)")
    }
}

class MediaItem {
    
    var name: String
    
    init(name: String) {
        
        self.name = name
    }
}

class Movie: MediaItem {
    
    var director: String
    
    init(name: String, director: String) {
        
        self.director = director
        
        super.init(name: name)
    }
}


class Song: MediaItem {
    
    var artist: String
    
    init(name: String, artist: String) {
        
        self.artist = artist
        super.init(name: name)
    }
}
