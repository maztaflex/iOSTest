//
//  ViewController.swift
//  FirstSwift
//
//  Created by DEV_TEAM1_IOS on 2015. 12. 10..
//  Copyright © 2015년 doozerstage. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        let board  = Checkerboard()
        
        print(board.squareIsBlackAtRow(0, column: 1))
        
        print(board.squareIsBlackAtRow(9, column: 9))
    }
}

struct Checkerboard {
    
    let boardColors: [Bool] = {
        
        var temporaryBoard = [Bool]()
        
        var isBlack = false
        
        for i in 1...10 {
            
            for j in 1...10 {
                
                temporaryBoard.append(isBlack)
                
                isBlack = !isBlack
            }
            
            isBlack = !isBlack
        }
        
        return temporaryBoard
    }()
    
    func squareIsBlackAtRow(row: Int, column: Int) -> Bool {
        
        return boardColors[(row * 10) + column]
    }
}

class AutomaticallyNamedDocument: Document {
    
    override init() {
        
        super.init()
        
        self.name = "[Unnamed]"
        
    }
    
    override init?(name: String) {
        
        super.init()
        
        if name.isEmpty {
            
            self.name = "[Unnamed]"
            
        } else {
            
            self.name = name
        }
    }
}

class Document {
    
    var name: String?
    
    init() {}
    
    init?(name: String) {
        
        self.name = name
        
        if name.isEmpty {return nil}
    }
}

class CartItem: Product {
    
    let quantity: Int!
    
    init?(name: String, quantity: Int) {
        
        self.quantity = quantity
        
        super.init(name: name)
        
        if quantity < 1 { return nil }
    }
}

enum NewTemperatureUnit: Character {
    
    case Kelvin = "K", Celcius = "C", Fahrenheit = "F"
}

enum TemperatureUnit {
    
    case Kelvin, Celsius, Fahrenheit
    
    init?(symbol: Character) {
        
        switch symbol {
            
        case "K":
            
            self = .Kelvin
            
        case "C":
            self = .Celsius
            
        case "F":
            self = .Fahrenheit
            
        default:
            return nil
        }
    }
}

class Product {
    
    let name: String!
    
    init?(name: String) {
        
        self.name = name
        
        if name.isEmpty { return nil }
    }
}

struct Animal {
    
    let species: String
    
    init?(species: String) {
        
        if species.isEmpty {return nil}
        
        self.species = species
    }
}

class ShoppingListItem: RecipeIngredient {
    
    var purchased = false
    
    var description: String {
        
        var output = "\(quantity) x \(name)"
        
        output += purchased ? " ✔" : " ✘"
        
        return output
    }
}

class RecipeIngredient: Food {
    
    var quantity: Int
    
    init(name: String, quantity: Int) {
        
        self.quantity = quantity
        
        super.init(name: name)
    }
    
    override convenience init(name: String) {
        
        self.init(name: name, quantity: 1)
    }
}

class Food {
    
    var name: String
    
    init(name: String) {
        
        self.name = name
    }
    
    convenience init()
    {
        self.init(name: "[Unnamed]")
    }
}

class AutomaticCar: Car {
    
    override var currentSpeed: Double {
        
        didSet {
            
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

class Car: Vehicle {
    
    var gear = 1
    
    override var description: String {
        
        return super.description + " in gear \(gear)"
    }
}

class Train: Vehicle {
    
    override func makeNoise() {
        
        print("Choo Choo")
    }
}

class Tandem : Bicycle{
    
    var currentNumberOfPassengers = 0
}

class Bicycle : Vehicle  {
    
    var hasBasket = false
    
}

class Vehicle {
    
    var currentSpeed = 0.0
    
    var description: String {
        
        return "traveling at \(currentSpeed) miles per hour"
    }
    
    func makeNoise() {
        
        // should be overrie
    }
}

struct Matrix {
    
    let rows: Int, columns: Int
    
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        
        self.rows = rows
        
        self.columns = columns
        
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        
        get {
            
            assert(indexIsValidForRow(row, column: column))
            
            return grid[(row * columns) + column]
        }
        
        set {
            
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            
            grid[(row * columns) + column] = newValue
        }
    }
}

struct TimesTable {
    
    let multiplier: Int
    
    subscript(index: Int) -> Int {
        
        return multiplier * index
    }
}

class Player {
    
    var tracker = LevelTracker()
    
    let playerName: String
    
    func completeLevel(level: Int) {
        
        LevelTracker.unlockLevel(level + 1)
        
        tracker.advanceToLevel(level + 1)
    }
    
    init(name: String) {
        
        playerName = name
    }
}

struct LevelTracker {
    
    static var highestUnlockedLevel = 1
    
    static func unlockLevel(level: Int) {
        
        if level > highestUnlockedLevel {
            
            highestUnlockedLevel = level
        }
    }
    
    static func levelIsUnlocked(level: Int) -> Bool {
        
        return level <= highestUnlockedLevel
    }
    
    var currentLevel = 1
    
    mutating func advanceToLevel(level: Int) -> Bool {
        
        if LevelTracker.levelIsUnlocked(level) {
            
            currentLevel = level
            
            return true
            
        } else {
            
            return false
        }
    }
}

enum TriStateSwich {
    
    case Off, Low, High
    
    mutating func next() {
        
        switch self {
            
        case Off:
            print("Off")
            self = Low
            
        case Low:
            print("Low")
            self = High
            
        case High:
            print("High")
            self = Off
        }
    }
}

struct AudioChannel {
    
    static let thresholdLevel = 10
    
    static var maxInputLevelForAllChannels = 0
    
    var currentLevel: Int = 0 {
        
        didSet {
            
            if currentLevel > AudioChannel.thresholdLevel {
                
                currentLevel = AudioChannel.thresholdLevel
            }
            
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

struct SomeStructure {
    
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        
        return 1
    }
}

enum SomeEnumeration {
    
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        
        return 6
    }
}

class SomeClass {
    
    static var storedTypeProperty = "Some value."
    
    static var computedTypeProperty: Int {
        
        return 27
    }
    
    class var overrideableComputedTypeProperty: Int {
        
        return 107
    }
}

class StepCounter {
    
    var totalSteps: Int = 0 {
        
        willSet {
            
            print("willSet : \(newValue)")
        }
        
        didSet {
            
            print("didSet : \(oldValue)")
        }
    }
}

struct Point
{
    var x = 0.0, y = 0.0
}

struct Size
{
    var width = 0.0, height = 0.0
}

struct Rect
{
    var origin = Point()
    var size = Size()
    var center: Point {
        
        get {
            
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            
            return Point(x: centerX, y: centerY)
        }
        
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

class DataImporter {
    
    var fileName = "data.txt"
}

class DataManager {
    
    lazy var importer = DataImporter()
    
    var data = [String]()
}


func backwards(s1: String, _ s2: String) -> Bool {
    
    return s1 > s2
}

func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
    
    func stepForward(input: Int) -> Int{
        
        return input + 1
    }
    
    func stepBackward(input: Int) -> Int {
        
        return input - 1
    }
    
    return backwards ? stepBackward : stepForward
}

func someFunction2(externalParameter localParameter:Int) {
    
}

func someFunction(firstParameterName: Int, _ secondParameterName: Int) -> Int {
    
    return firstParameterName + secondParameterName
}

func swapTwoInts(inout a: Int, inout _ b: Int) {
    
    let temporaryA = a
    
    a = b
    
    b = temporaryA
}

func alightRight(var string: String, totalLength: Int, pad: Character) -> String {
    
    let amountToPad = totalLength - string.characters.count
    
    if amountToPad < 1 {
        
        return string
    }
    
    let padString = String(pad)
    
    for _ in 1...amountToPad {
        
        string = padString + string
    }
    
    return string
}

func arithmeticMean(numbers:Double...) -> Double{
    
    var total: Double = 0
    
    for number in numbers {
        
        total += number
    }
    
    return total / Double(numbers.count)
}

func somFunc(value:Int = 10) {
    
    print(value)
}

func anyCommonElements <T: SequenceType, U: SequenceType where
    T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element> (lhs: T, _ rhs: U) -> Bool {
        
        for lhsItem in lhs {
            
            for rhsItem in rhs {
                
                if lhsItem == rhsItem {
                    
                    return true
                }
            }
        }
        
        return false
}

enum OptionalValue<Wrapped> {
    
    case None
    
    case Some(Wrapped)
}

func repeatItem<Item>(item: Item, numberOfTimes: Int) -> [Item] {
    
    var result = [Item]()
    
    for _ in 0..<numberOfTimes {
        
        result.append(item)
    }
    
    return result
}

extension Int: ExampleProtocol {
    
    var simpleDescription: String {
        
        return "The number \(self)"
    }
    
    mutating func adjust() {
        
        self += 42
    }
}

protocol ExampleProtocol {
    
    var simpleDescription: String { get }
    
    mutating func adjust()
}

struct SimpleStructure:ExampleProtocol {
    
    var simpleDescription: String = "A simple structure"
    
    mutating func adjust() {
        
        simpleDescription += " (adjusted)"
    }
}

class SimpleClass: ExampleProtocol {
    
    var simpleDescription: String = "A very simple class"
    
    var anotherProperty: Int = 69105
    
    func adjust() {
        
        simpleDescription += " Now 100% adjusted."
    }
}

enum ServerResponse {
    
    case Result(String, String)
    
    case Error(String)
}

struct Card {
    
    var rank: Rank
    
    var suit: Suit
    
    func simpleDesc() -> String {
        
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}


enum Suit {
    
    case Spades, Hearts, Diamonds, Clubs
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .Spades:
            
            return "spades"
            
        case .Hearts:
            
            return "hearts"
            
        case .Diamonds:
            
            return "diamonds"
            
        case .Clubs:
            
            return "clubs"
        }
    }
    
    func color() -> String {
        
        switch self{
            
        case .Spades:
            
            return "black"
            
        case .Clubs:
            
            return "black"
            
        case .Hearts:
            
            return "red"
            
        case .Diamonds:
            
            return "red"
        }
    }
}

enum Rank: Int {
    
    case Ace = 1
    
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    
    case Jack, Queen, King
    
    func simpleDescription() -> String {
        
        switch self {
            
        case .Ace:
            
            return "ace"
        case .Jack:
            
            return "jack"
            
        case .Queen:
            
            return "queen"
            
        case .King:
            
            return "king"
        default:
            
            return String(self.rawValue)
        }
    }
}

class TriangleAndSquare {
    
    var triangle: EquilateralTriangle {
        
        willSet {
            
            square.sideLength = newValue.sideLength
            print("square.sideLength = newValue.sideLength")
            
        }
    }
    
    var square: Square {
        
        willSet {
            
            triangle.sideLength = newValue.sideLength
            print("triangle.sideLength = newValue.sideLength")
        }
    }
    
    init(size: Double, name: String) {
        
        square = Square(sideLength: size, name: name)
        
        triangle = EquilateralTriangle(sideLength: size, name: name)
    }
}

class EquilateralTriangle: NamedShape {
    
    var sideLength: Double = 0.0
    
    init(sideLength: Double, name: String) {
        
        self.sideLength = sideLength
        
        super.init(name: name)
        
        numberOfSides = 3
    }
}

class Circle: NamedShape {
    
    var radious: Double
    
    init(radious: Double, name: String) {
        
        self.radious = radious
        
        super.init(name: name)
    }
    
    var perimeter: Double {
        
        get {
            return 3.0 * radious
        }
        
        set {
            
            radious = newValue / 3.0
        }
    }
    
    func area() -> Double {
        
        return self.radious * 3.14
    }
    
    override func simpleDesc() -> String {
        return "A circle radious is \(self.radious)"
    }
}

class Square: NamedShape {
    
    var sideLength: Double
    
    init(sideLength: Double, name: String) {
        
        self.sideLength = sideLength
        
        super.init(name: name)
        
        numberOfSides = 4
    }
    
    
    
    func area() -> Double {
        
        return sideLength * sideLength
    }
    
    override func simpleDesc() -> String {
        
        return "A square with sides of length \(sideLength). "
    }
}

class NamedShape {
    
    var numberOfSides: Int = 0
    
    var name: String
    
    init(name: String) {
        
        self.name = name
    }
    
    func simpleDesc() -> String {
        
        return "A shape with \(self.name) sides"
    }
}
