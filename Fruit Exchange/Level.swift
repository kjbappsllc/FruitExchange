//
//  Level.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation

class Level {
    
    private var fruits: Array2D<Fruit>!
    private var tiles: Array2D<Tile>!
    private var goal: Array2D<Fruit>!
    private var _maximumMoves = 0
    
    var maximumMoves: Int {
        get {
            return _maximumMoves
        }
    }
    
    private var _gridSize = 0
    
    var gridSize: Int {
        get {
            return _gridSize
        }
    }
    
    init(filename: String) {
        
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) else { return }
        
        _gridSize = dictionary["Grid"] as! Int
        
        setUpArrays(gridSize: _gridSize)
    
        guard let tilesArray = dictionary["Tiles"] as? [[Int]] else { return }
        
        guard let fruitsArray = dictionary["Start"] as? [[Int]] else { return }
        
        guard let goalArray = dictionary["Goal"] as? [[Int]] else { return }
        
        setUpLevel(tilesArray: tilesArray, fruitsArray: fruitsArray, goalArray: goalArray)
        
        _maximumMoves = dictionary["Moves"] as! Int
    }
    
    private func setUpArrays(gridSize: Int) {
        fruits = Array2D<Fruit>(columns: gridSize, rows: gridSize)
        tiles = Array2D<Tile>(columns: gridSize, rows: gridSize)
        goal = Array2D<Fruit>(columns: gridSize, rows: gridSize)
    }
    
    func setUpLevel(tilesArray: [[Int]], fruitsArray: [[Int]], goalArray: [[Int]]) {
        // 3
        for (row, rowArray) in tilesArray.enumerated() {
            // 4
            let tileRow = _gridSize - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        
        for (row, fruitsArray) in fruitsArray.enumerated() {
            // 5
            for (column, value) in fruitsArray.enumerated() {
                if value != 0 {
                    var fruitType: FruitType
                    fruitType = FruitType.getFruitType(value)
                    
                    let fruit = Fruit(column: column, row: row, fruitType: fruitType)
                    fruits[column,row] = fruit
                }
            }
        }
        
        for (row, goalArray) in goalArray.enumerated() {
            // 5
            for (column, value) in goalArray.enumerated() {
                if value != 0 {
                    var fruitType: FruitType
                    fruitType = FruitType.getFruitType(value)
                    
                    let fruit = Fruit(column: column, row: row, fruitType: fruitType)
                    goal[column,row] = fruit
                }
            }
        }
    }
    
    func createInitialFruit() -> Set<Fruit> {
        var set = Set<Fruit>()
        
        for row in 0..<_gridSize {
            for column in 0..<_gridSize{
                
                if tiles[column,row] != nil {
                    let fruit = fruits[column,row]
                    set.insert(fruit!)
                }
            }
        }
        return set
    }
    
    func FruitAtColumn(_ column: Int, row: Int) -> Fruit? {
        assert(column >= 0 && column < _gridSize)
        assert(row >= 0 && row < _gridSize)
        return fruits[column,row]
    }
    
    func tileAtColumn(_ column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < _gridSize)
        assert(row >= 0 && row < _gridSize)
        return tiles[column, row]
    }
    
    func isCorrectPattern() -> Bool {
        var isPattern = Bool()
        
        for row in 0..<_gridSize {
            for column in 0..<_gridSize {
                if let fruit = fruits[column,row] {
                    if fruit.fruitType == goal[column,row]?.fruitType {
                        isPattern = true
                    }
                    else if fruit.fruitType != goal[column,row]?.fruitType {
                        isPattern = false
                        return isPattern
                    }
                }
            }
        }

        return isPattern
    }
    
    func performSwap(_ swap: Swap) {
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
    
    func changeToComplement(_ swap:Swap) {
        if swap.isComplement() == false {
            swap.fruitA.fruitType = FruitType.getComplementType(swap.fruitA.fruitType.rawValue)
            swap.fruitB.fruitType = FruitType.getComplementType(swap.fruitB.fruitType.rawValue)
        }
    }
}
