//
//  Array2D.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let columns: Int
    let rows: Int
    private var array: Array<T?>
    
    init(columns:Int, rows:Int) {
        self.columns = columns
        self.rows = rows
        self.array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
