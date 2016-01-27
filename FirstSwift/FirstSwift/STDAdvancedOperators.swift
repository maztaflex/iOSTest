//
//  STDAdvancedOperators.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 11..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

import UIKit
import Foundation

class STDAdvancedOperators: UIViewController {
    
    override func viewDidLoad() {
        
        print("Subject : Advanced Operators")
        
        let initialBits: UInt8 = 0b00001111
        
        let invertedBits = ~initialBits
        
        print("invertedBits : \(invertedBits)")
        
        let firstSixBits: UInt8 = 0b11111100
        
        let lastSixBits: UInt8 = 0b00111111
        
        let middleFourBits = firstSixBits & lastSixBits
        
        print("middleFourBits : \(middleFourBits)")
    }
}
