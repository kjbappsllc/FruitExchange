//
//  Grid.swift
//  SwiftXcodePractice
//
//  Created by Mac on 2/26/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import UIKit
import SpriteKit

class Grid: SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    var selectionSprite = SKSpriteNode()
    var spriteSize: CGFloat = 0
    
    private var _swipeHandler: ((Swap) -> ())?
    
    var swipeHandler: ((Swap) -> ())? {
        get {
            return _swipeHandler
        }
        set {
            _swipeHandler = newValue
        }
    }
    
    fileprivate var swipeFromColumn: Int?
    fileprivate var swipeFromRow: Int?
    
    private var _level: Level!
    
    var level: Level {
        get {
            return _level
        }
        set {
            _level = newValue
        }
    }
    
    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:UIColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        swipeFromColumn = nil
        swipeFromRow = nil
        self.isUserInteractionEnabled = true
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor(colorLiteralRed: 184/255, green: 184/255, blue: 184/255, alpha: 0.66).setStroke()
        bezierPath.lineWidth = 3.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = blockSize / 2.0 + 0.5
        let y = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
        let x = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x:y, y:x)
    }
    
    func convertPoint(_ point: CGPoint) -> (column: Int, row: Int) {
        let x = size.width / 2 + point.x
        let y = size.height / 2 - point.y
        let row = Int(floor(y / blockSize))
        let col = Int(floor(x / blockSize))
        
        return (row,col)
        
    }
    
    func showSelectionIndicatorForFruit(_ fruit: Fruit) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = fruit.sprite {
            let texture = SKTexture(imageNamed: fruit.fruitType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: spriteSize - 20, height: spriteSize - 20)
            selectionSprite.run(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()]))
    }
    
    func trySwapHorizontal(_ horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        // 2
        guard toColumn >= 0 && toColumn < level.gridSize else { return }
        guard toRow >= 0 && toRow < level.gridSize else { return }
        // 3
        if let toFruit = level.FruitAtColumn(toColumn, row: toRow),
            let fromFruit = level.FruitAtColumn(swipeFromColumn!, row: swipeFromRow!) {
            // 4
            if let handler = swipeHandler {
                let swap = Swap(fruitA: fromFruit, fruitB: toFruit)
                print(swap)
                handler(swap)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let position = touch.location(in:self)
            let (row,col) = convertPoint(position)
            //print("\(row) \(col)")
            
            if let fruit = level.FruitAtColumn(col, row: row){
                // 4
                swipeFromColumn = col
                swipeFromRow = row
                showSelectionIndicatorForFruit(fruit)
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        
        guard swipeFromColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let (row, col) = convertPoint(location)
            // 3
        var horzDelta = 0, vertDelta = 0
        if col < swipeFromColumn! {          // swipe left
            horzDelta = -1
        } else if col > swipeFromColumn! {   // swipe right
            horzDelta = 1
        } else if row < swipeFromRow! {         // swipe down
            vertDelta = -1
        } else if row > swipeFromRow! {         // swipe up
            vertDelta = 1
        }
        
        // 4
        if horzDelta != 0 || vertDelta != 0 {
            trySwapHorizontal(horzDelta, vertical: vertDelta)
            hideSelectionIndicator()
            // 5
            swipeFromColumn = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touches = touches
        touchesEnded(touches, with: event)
    }
}
