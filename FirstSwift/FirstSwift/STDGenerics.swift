//
//  STDGenerics.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2016. 1. 7..
//  Copyright © 2016년 doozerstage. All rights reserved.
//

import UIKit
import Foundation

protocol Container {
    
    typealias ItemType
    
    mutating func append(item: ItemType)
    
    var count: Int { get }
    
    subscript(i: Int) -> ItemType { get }
    
}


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
//        stackOfStrings.push("cuatro")
//
//        let fromTheTop = stackOfStrings.pop()
//        print(fromTheTop)
//        
//        if let topItem = stackOfStrings.topItem {
//            
//            print("The top item on the stack is \(topItem)")
//        }
//        
//        let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
//        
//        if let foundIndex = findStringIndex(strings, "llama") {
//            
//            print("The index of llama is \(foundIndex)")
//        }
//        
//        let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
//        
//        print("doubleIndex : \(doubleIndex)")
//        
//        let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")
//        
//        print("stringIndex : \(stringIndex)")
        
        
        let arrayOfString = ["uno", "dos", "tres"]
        
        if allItemsMatch(stackOfStrings, arrayOfString) {
            
            print("All items match")
            
        } else {
            
            print("Not all items match")
        }
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

struct IntStack: Container {
    
    // Original IntStack implementation
    var items = [Int]()
    
    mutating func push(item: Int) {
        
        items.append(item)
    }
    
    mutating func pop() -> Int {
        
        return items.removeLast()
    }
    
    // conformance to the Container protocol
    typealias ItemType = Int
    
    mutating func append(item: Int) {
        
        self.push(item)
    }
    
    var count: Int {
        
        return items.count
    }
    
    subscript(i: Int) -> Int {
        
        return items[i]
    }
}

struct Stack<Element>: Container {
    
    var items = [Element]()
    
    mutating func push(item: Element) {
        
        items.append(item)
    }
    
    mutating func pop() -> Element {
        
        return items.removeLast()
    }
    
    // conformance to the Container protocol
    mutating func append(item: Element) {
        
        self.push(item)
    }
    
    var count: Int {
        
        return items.count
    }
    
    subscript(i: Int) -> Element {
        
        return items[i]
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


extension Array: Container {}

func allItemsMatch<
    C1: Container,
    C2: Container where C1.ItemType == C2.ItemType,
    C1.ItemType: Equatable>(someContainer: C1, _ anotherContainer: C2) -> Bool {
        
        if someContainer.count != anotherContainer.count {
            
            return false
        }
        
        // check each pair of items to see if they are equivalent
        for i in 0..<someContainer.count {
            
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // all items match, so return true
        
        return true
}













