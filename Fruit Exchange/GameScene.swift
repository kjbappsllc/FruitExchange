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
    var patternButton = SKSpriteNode()
    private var HUD = SKSpriteNode()
    
    var swipeHandler: ((Swap) -> ())?
    
    var level: Level!
    var movesLabel = SKLabelNode()
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    let TileWidth: CGFloat = 48.0 * 1.6
    let TileHeight: CGFloat = 52.0 * 1.6
    
    private let gameLayer = SKNode()
    private let fruitsLayer = SKNode()
    private let tilesLayer = SKNode()
    private let hudLayer = SKNode()
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        addChild(background)
        
        addChild(gameLayer)
        gameLayer.hidden = true
        hudLayer.hidden = true
        movesLabel.alpha = 0
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        fruitsLayer.position = layerPosition
        gameLayer.addChild(fruitsLayer)
        
        hudLayer.position = CGPoint(x: 0, y: self.frame.height/2)
        self.addChild(hudLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    func addHud() {
        HUD = SKSpriteNode(imageNamed: "topBar")
        
        HUD.size = CGSize(width: HUD.size.width * 2, height: HUD.size.height * 2)
        HUD.position = CGPoint(x: 0, y: -HUD.size.height/2)
        
        movesLabel.fontSize = 80.0
        movesLabel.fontName = "Hercules"
        movesLabel.fontColor = SKColor(red: 248/255, green: 106/255, blue: 106/255, alpha: 1.0)
        movesLabel.position = CGPoint(x: 0, y: 35)
        movesLabel.text = String(level.maximumMoves)
        
        patternButton = SKSpriteNode(imageNamed: "patternButton")
        patternButton.size = CGSize(width: patternButton.size.width * 2, height: patternButton.size.height * 2)
        patternButton.position = CGPoint(x: 0, y: -(HUD.size.height / 2) + 70)
        
        hudLayer.addChild(HUD)
        HUD.addChild(movesLabel)
        HUD.addChild(patternButton)
    }
    
    func updateMovesLabel(number: Int) {
        movesLabel.text = String(number)
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
                var tileNode = SKSpriteNode()
                if level.tileAtColumn(column, row: row) != nil {
                    if (column % 2 == 0 && row % 2 == 0) || (column % 2 != 0 && row % 2 != 0) {
                        tileNode = SKSpriteNode(imageNamed: "Tile2")
                    }
                    else {
                        tileNode = SKSpriteNode(imageNamed: "Tile1")
                    }
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
        
        if swap.isComplement() == false {
            var spriteA = swap.fruitA.sprite!
            var spriteB = swap.fruitB.sprite!

            let scaleA = SKAction.scaleTo(1.1, duration: 0.1)
            
            spriteA.removeFromParent()
            spriteA = SKSpriteNode(imageNamed: swap.fruitA.fruitType.spriteName)
            swap.fruitA.sprite = spriteA
            
            spriteA.position = pointForColumn(swap.fruitA.column, row:swap.fruitA.row)
            spriteA.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteA)
            spriteA.runAction(SKAction.sequence([scaleA, SKAction.scaleTo(1.0, duration: 0.1)]))
            
            let scaleB = SKAction.scaleTo(1.05, duration: 0.1)
            spriteB.removeFromParent()
            spriteB = SKSpriteNode(imageNamed: swap.fruitB.fruitType.spriteName)
            swap.fruitB.sprite = spriteB
            
            spriteB.position = pointForColumn(swap.fruitB.column, row:swap.fruitB.row)
            spriteB.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteB)
            spriteB.runAction(SKAction.sequence([scaleB, SKAction.scaleTo(1.0, duration: 0.1)]),completion:completion)
        }
        else{
            self.runAction(SKAction.waitForDuration(0), completion: completion)
        }
    }
    
    func animateGameOver(completion: () -> ()) {
        let action = SKAction.moveBy(CGVector(dx: size.width, dy: 0), duration: 0.4)
        action.timingMode = .EaseIn
        gameLayer.runAction(action, completion: completion)
        
        let action2 = SKAction.moveBy(CGVector(dx: 0, dy: size.height), duration: 0.8)
        action2.timingMode = .EaseIn
        hudLayer.runAction(action2)
    }
    
    func animateBeginGame() {
        gameLayer.hidden = false
        gameLayer.position = CGPoint(x: size.width, y: 0)
        let gameLayerMove = SKAction.moveBy(CGVector(dx: -size.width, dy: 0), duration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7)
        gameLayerMove.timingMode = .EaseOut
        gameLayer.runAction(gameLayerMove)
        
        hudLayer.hidden = false
        hudLayer.position = CGPoint(x: 0, y: size.height)
        let hudAction = SKAction.moveBy(CGVector(dx: 0, dy: -size.height/2), duration: 0.5, delay: 0.2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9)
        hudAction.timingMode = .EaseOut
        hudLayer.runAction(hudAction)
        
        let movesAction = SKAction.fadeInWithDuration(0.4, delay: 0.3, usingSpringWithDamping: 0.2, initialSpringVelocity: 0)
        movesAction.timingMode = .EaseIn
        let moveScaleAction = SKAction.scaleTo(1.1, duration: 0.9, delay: 0.5, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1)
        movesLabel.runAction(SKAction.group([movesAction,moveScaleAction]))
    }
    
    func removeAllFruitSprites() {
        fruitsLayer.removeAllChildren()
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
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
