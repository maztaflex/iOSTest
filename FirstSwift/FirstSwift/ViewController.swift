//
//  ViewController.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 10..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

import UIKit

extension Double {
    
    var km: Double { return self * 1_000.0 }
    
    var m: Double { return self }
    
    var cm: Double { return self / 100.0 }
    
    var mm: Double { return self / 1_000.0 }
    
    var ft: Double { return self / 3.28084 }
}

struct Size {
    
    var width = 0.0, height = 0.0
}

struct Point {
    
    var x = 0.0, y = 0.0
}

struct Rect {
    
    var origin = Point()
    
    var size = Size()
}

extension Rect {
    
    init(center: Point, size: Size) {
        
        let originX = center.x - (size.width / 2)
        
        let originY = center.y - (size.height / 2)
        
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

extension Int {
    
    subscript(var digitIndex: Int) -> Int {
        
        var decimalBase = 1
        
        while digitIndex > 0 {
            
            decimalBase *= 10
            
            --digitIndex
        }
        
        return (self / decimalBase) % 10
    }
    
    enum Kind {
        
        case Negative, Zero, Positive
    }
    
    var kind: Kind {
        
        switch self {
            
        case 0:
            
            return .Zero
            
        case let x where x > 0:
            
            return .Positive
            
        default:
            
            return .Negative
        }
    }
}

func printIntegerKinds(numbers: [Int]) {
    
    for number in numbers {
        
        switch number.kind {
            
        case .Negative:
            
            print("- ", terminator: "")
            
        case .Zero:
            
            print("0 ", terminator: "")
            
        case .Positive:
            
            print("+ ", terminator: "")
        }
    }
    
    print("")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        print("\(736381295[8])")
        
        let someInt = -1
        
        print(someInt.kind)
        
        printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
        
    }
}


