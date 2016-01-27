//
//  STDAccessControl.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 11..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

import UIKit

import Foundation

class STDAccessControl: UIViewController {
    
    override func viewDidLoad() {
        print("Subject : AccessControl\n")
        
        var stringToEdit = TrackedString()
        
        stringToEdit.value = "This string will be tracked."
        
        stringToEdit.value += " This edit will increment numberOfEdits."
        
        stringToEdit.value += " So will this one."
        
        print("The number of edit is \(stringToEdit.numberOfEdits)")
    }
}

public struct TrackedString {
    
    private(set) var numberOfEdits = 0
    
    public var value: String = "" {
        
        didSet {
            
            numberOfEdits++
        }
    }
    
    public init() {}
}