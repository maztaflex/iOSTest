//
//  STDGenerics.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 7..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

import UIKit
import Foundation

class STDGenerics: UIViewController {
    
    override func viewDidLoad() {
        
//        var someInt = 3
//        
//        var anotherInt = 107
//        
//        swapTwoValues(&someInt, &anotherInt)
//        
//        print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
//        
//        var someString = "hello"
//        
//        var anotherString = "world"
//        
//        swapTwoValues(&someString, &anotherString)
//        
//        print("someString is now \(someString), and anotherString is now \(anotherString)")
        
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        stackOfStrings.push("cuatro")
        
        let fromTheTop = stackOfStrings.pop()
        print(fromTheTop)
        
        if let topItem = stackOfStrings.topItem {
            
            print("The top item on the stack is \(topItem)")
        }
        
        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
        
        if let foundIndex = findStringIndex(strings, "llama") {
            
            print("The index of llama is \(foundIndex)")
        }
        
        let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
        
        print("doubleIndex : \(doubleIndex)")
        
        let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")
        
        print("stringIndex : \(stringIndex)")
    }
}

func swapTwoInts(inout a: Int, inout _ b: Int) {
    
    let temporaryA = a
    
    a = b
    
    b = temporaryA
}

func swapTwoStrings(inout a: String, inout _ b: String) {
    
    let temporaryA = a
    
    a = b
    
    b = temporaryA
}

func swapTwoDoubles(inout a: Double, inout _ b: Double) {
    
    let temporaryA = a
    
    a = b
    
    b = temporaryA
}

func swapTwoValues<TK>(inout a: TK, inout _ b: TK) {
    
    let temporaryA = a
    
    a = b
    
    b = temporaryA
}

struct IntStack {
    
    var items = [Int]()
    
    mutating func push(item: Int) {
        
        items.append(item)
    }
    
    mutating func pop() -> Int {
        
        return items.removeLast()
    }
}

struct Stack<Element> {
    
    var items = [Element]()
    
    mutating func push(item: Element) {
        
        items.append(item)
    }
    
    mutating func pop() -> Element {
        
        return items.removeLast()
    }
}

extension Stack {
    
    var topItem: Element? {
        
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

func findStringIndex(array: [String], _ valueToFind: String) -> Int? {
    
    for (index, value) in array.enumerate() {
        
        if value == valueToFind {
            
            return index
        }
    }
    
    return nil
}

func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
    
    for (index, value) in array.enumerate() {
        
        if value == valueToFind {
            
            return index
        }
    }
    
    return nil
}

















