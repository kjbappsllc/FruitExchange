//
//  Fruit.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation
import SpriteKit

enum FruitType: Int {
    case Unknown = 0, Apple, Pear, Grape, Banana, Blueberry, Orange
    
    var spriteName: String {
        let spritenames = [
            "Apple",
            "Pear",
            "Grape",
            "Banana",
            "Blueberry",
            "Orange"
        ]
        return spritenames[rawValue - 1]
    }
    
    var complementSpriteName: String {
        var complement = String()
        
        switch spriteName {
            
        case "Apple":
            complement = "Pear"
        
        case "Pear":
            complement = "Apple"
        
        case "Grape":
            complement = "Banana"
            
        case "Banana":
            complement = "Grape"
            
        case "Blueberry":
            complement = "Orange"
            
        case "Orange":
            complement = "Blueberry"
            
        default:
            break
        }
        
        return complement
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func getFruitType(num: Int) -> FruitType {
        return FruitType(rawValue: num)!
    }
    
    static func getComplementType(type: Int) -> FruitType {
        var fruitType = FruitType(rawValue: type)
        if let sprite = fruitType?.spriteName {
        
            switch sprite {
                
            case "Apple":
                fruitType = getFruitType(2)
                
            case "Pear":
                fruitType = getFruitType(1)
                
            case "Grape":
                fruitType = getFruitType(4)
                
            case "Banana":
                fruitType = getFruitType(3)
                
            case "Blueberry":
                fruitType = getFruitType(6)
                
            case "Orange":
                fruitType = getFruitType(5)
                
            default:
                break
            }
        }
        
        return fruitType!
    }
}

class Fruit: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var fruitType: FruitType
    var sprite: SKSpriteNode?
    
    var description: String {
        return "type: \(fruitType) complement: \(fruitType.complementSpriteName) square: (\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
    init(column: Int, row: Int, fruitType: FruitType) {
        self.column = column
        self.row = row
        self.fruitType = fruitType
    }
}

func ==(lhs: Fruit, rhs: Fruit) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}