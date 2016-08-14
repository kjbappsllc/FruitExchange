//
//  GameScene.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var selectionSprite = SKSpriteNode()
    
    var swipeHandler: ((Swap) -> ())?
    
    var level: Level!
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    let TileWidth: CGFloat = 48.0*1.7
    let TileHeight: CGFloat = 52.0*1.7
    
    let gameLayer = SKNode()
    let fruitsLayer = SKNode()
    private let tilesLayer = SKNode()
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        fruitsLayer.position = layerPosition
        gameLayer.addChild(fruitsLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    func addSpritesForFruit(fruits: Set<Fruit>) {
        for fruit in fruits {
            let sprite = SKSpriteNode(imageNamed: fruit.fruitType.spriteName)
            sprite.position = pointForColumn(fruit.column, row:fruit.row)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(sprite)
            fruit.sprite = sprite
        }
    }

    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if level.tileAtColumn(column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "Tile")
                    tileNode.size = CGSize(width: TileWidth, height: TileHeight)
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func showSelectionIndicatorForFruit(fruit: Fruit) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = fruit.sprite {
            let texture = SKTexture(imageNamed: fruit.fruitType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
            selectionSprite.runAction(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }
    
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.fruitA.sprite!
        let spriteB = swap.fruitB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: NSTimeInterval = 0.3
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion: completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    func changeSprites(swap:Swap, completion: () -> ()) {
        var spriteA = swap.fruitA.sprite!
        var spriteB = swap.fruitB.sprite!
        
        print(swap)
        if swap.isComplement() == false {
            let scaleA = SKAction.scaleTo(1.1, duration: 0.1)
            
            spriteA.removeFromParent()
            spriteA = SKSpriteNode(imageNamed: swap.fruitA.fruitType.complementSpriteName)
            swap.fruitA.sprite = spriteA
            swap.fruitA.fruitType = FruitType.getComplementType(swap.fruitA.fruitType.rawValue)
            
            spriteA.position = pointForColumn(swap.fruitA.column, row:swap.fruitA.row)
            spriteA.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteA)
            spriteA.runAction(SKAction.sequence([scaleA, SKAction.scaleTo(1.0, duration: 0.1)]))
            
            let scaleB = SKAction.scaleTo(1.05, duration: 0.1)
            spriteB.removeFromParent()
            spriteB = SKSpriteNode(imageNamed: swap.fruitB.fruitType.complementSpriteName)
            swap.fruitB.sprite = spriteB
            swap.fruitB.fruitType = FruitType.getComplementType(swap.fruitB.fruitType.rawValue)
            
            spriteB.position = pointForColumn(swap.fruitB.column, row:swap.fruitB.row)
            spriteB.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteB)
            spriteB.runAction(SKAction.sequence([scaleB, SKAction.scaleTo(1.0, duration: 0.1)]))
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        let location = touch.locationInNode(fruitsLayer)
        // 2
        let (success, column, row) = convertPoint(location)
        if success {
            // 3
            if let fruit = level.FruitAtColumn(column, row: row){
                // 4
                swipeFromColumn = column
                swipeFromRow = row
                showSelectionIndicatorForFruit(fruit)
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1
        guard swipeFromColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.locationInNode(fruitsLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            
            // 3
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
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
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if let touches = touches {
            touchesEnded(touches, withEvent: event)
        }
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
        // 2
        guard toColumn >= 0 && toColumn < NumColumns else { return }
        guard toRow >= 0 && toRow < NumRows else { return }
        // 3
        if let toFruit = level.FruitAtColumn(toColumn, row: toRow),
            let fromFruit = level.FruitAtColumn(swipeFromColumn!, row: swipeFromRow!) {
            // 4
            if let handler = swipeHandler {
                let swap = Swap(fruitA: fromFruit, fruitB: toFruit)
                handler(swap)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
