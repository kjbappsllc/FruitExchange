//
//  Level.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation

let NumColumns = 6
let NumRows = 6

class Level {
    
    private var fruits = Array2D<Fruit>(columns: NumColumns, rows: NumRows)
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
    private var goal = Array2D<Fruit>(columns: NumColumns, rows: NumRows)
    
    init(filename: String) {
        // 1
        
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) else { return }
        // 2
        guard let tilesArray = dictionary["Tiles"] as? [[Int]] else { return }
        
        guard let fruitsArray = dictionary["Start"] as? [[Int]] else { return }
        
        // 3
        for (row, rowArray) in tilesArray.enumerate() {
            // 4
            let tileRow = NumRows - row - 1
            // 5
            for (column, value) in rowArray.enumerate() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        
        for (row, fruitsArray) in fruitsArray.enumerate() {
            // 4
            let fruitRow = NumRows - row - 1
            // 5
            for (column, value) in fruitsArray.enumerate() {
                if value != 0 {
                    var fruitType: FruitType
                    fruitType = FruitType.getFruitType(value)
                    
                    let fruit = Fruit(column: column, row: fruitRow, fruitType: fruitType)
                    fruits[column,fruitRow] = fruit
                }
            }
        }
        
    }
    
    func createInitialFruit() -> Set<Fruit> {
        var set = Set<Fruit>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                if tiles[column,row] != nil {
                    let fruit = fruits[column,row]
                    set.insert(fruit!)
                }
            }
        }
        return set
    }
    
    func FruitAtColumn(column: Int, row: Int) -> Fruit? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return fruits[column,row]
    }
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    func performSwap(swap: Swap) {
        let columnA = swap.fruitA.column
        let rowA = swap.fruitA.row
        let columnB = swap.fruitB.column
        let rowB = swap.fruitB.row
        
        fruits[columnA,rowA] = swap.fruitB
        swap.fruitB.column = columnA
        swap.fruitB.row = rowA
            
        fruits[columnB,rowB] = swap.fruitA
        swap.fruitA.column = columnB
        swap.fruitA.row = rowB
    }
}