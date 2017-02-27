//
//  Swap.swift
//  Fruit Exchange
//
//  Created by Mac on 8/12/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation

struct Swap: CustomStringConvertible, Hashable{
    let fruitA: Fruit
    let fruitB: Fruit
    
    init(fruitA: Fruit, fruitB: Fruit) {
        self.fruitA = fruitA
        self.fruitB = fruitB
    }
    
    var description: String {
        return "swap \(fruitA) with \(fruitB)"
    }
    
    var hashValue: Int {
        return fruitA.hashValue ^ fruitB.hashValue
    }
    
    func isComplement() -> Bool{
        var complement = Bool()
        
        if fruitA.fruitType.complementSpriteName == fruitB.fruitType.spriteName {
            complement = true
        }
        else {
            complement = false
        }
        
        return complement
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.fruitA == rhs.fruitA && lhs.fruitB == rhs.fruitB) ||
        (lhs.fruitB == rhs.fruitA && lhs.fruitA == rhs.fruitB)
}
