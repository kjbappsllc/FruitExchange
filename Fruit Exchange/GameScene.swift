//
//  GameScene.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    private var selectionSprite = SKSpriteNode()
    
    private var _level: Level!
    private var movesLabel = SKLabelNode()
    
    fileprivate var swipeFromColumn: Int?
    fileprivate var swipeFromRow: Int?
    
    private let TileWidth: CGFloat = 48.0 * 1.6
    private let TileHeight: CGFloat = 52.0 * 1.6
    
    private let gameLayer = SKNode()
    private let hudLayer = SKNode()
    private let fruitsLayer = SKNode()
    private let tilesLayer = SKNode()
    
    private var _swipeHandler: ((Swap) -> ())?
    
    var swipeHandler: ((Swap) -> ())? {
        get {
            return _swipeHandler
        }
        set {
            _swipeHandler = newValue
        }
    }
    
    var level: Level {
        get {
            return _level
        }
        set {
            _level = newValue
        }
    }
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        addChild(background)
        
        addChild(gameLayer)
        gameLayer.isHidden = true
        movesLabel.alpha = 0
        
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
    
    func updateMovesLabel(_ number: Int) {
        movesLabel.text = String(number)
    }
    
    func addSpritesForFruit(_ fruits: Set<Fruit>) {
        for fruit in fruits {
            let sprite = SKSpriteNode(imageNamed: fruit.fruitType.spriteName)
            sprite.position = pointForColumn(fruit.column, row:fruit.row)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(sprite)
            fruit.sprite = sprite
        }
    }

    func pointForColumn(_ column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
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
    
    func showSelectionIndicatorForFruit(_ fruit: Fruit) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = fruit.sprite {
            let texture = SKTexture(imageNamed: fruit.fruitType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
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
    
    func animateSwap(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.fruitA.sprite!
        let spriteB = swap.fruitB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: Duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: Duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }
    
    func changeSprites(_ swap:Swap, completion: @escaping () -> ()) {
        
        if swap.isComplement() == false {
            var spriteA = swap.fruitA.sprite!
            var spriteB = swap.fruitB.sprite!

            let scaleA = SKAction.scale(to: 1.1, duration: 0.1)
            
            spriteA.removeFromParent()
            spriteA = SKSpriteNode(imageNamed: swap.fruitA.fruitType.spriteName)
            swap.fruitA.sprite = spriteA
            
            spriteA.position = pointForColumn(swap.fruitA.column, row:swap.fruitA.row)
            spriteA.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteA)
            spriteA.run(SKAction.sequence([scaleA, SKAction.scale(to: 1.0, duration: 0.1)]))
            
            let scaleB = SKAction.scale(to: 1.05, duration: 0.1)
            spriteB.removeFromParent()
            spriteB = SKSpriteNode(imageNamed: swap.fruitB.fruitType.spriteName)
            swap.fruitB.sprite = spriteB
            
            spriteB.position = pointForColumn(swap.fruitB.column, row:swap.fruitB.row)
            spriteB.size = CGSize(width: TileWidth, height: TileHeight)
            fruitsLayer.addChild(spriteB)
            spriteB.run(SKAction.sequence([scaleB, SKAction.scale(to: 1.0, duration: 0.1)]),completion:completion)
        }
        else{
            self.run(SKAction.wait(forDuration: 0), completion: completion)
        }
    }
    
    func animateGameOver(_ completion: @escaping () -> ()) {
        let action = SKAction.move(by: CGVector(dx: size.width, dy: 0), duration: 0.4)
        action.timingMode = .easeIn
        gameLayer.run(action, completion: completion)
    }
    
    func animateBeginGame() {
        gameLayer.isHidden = false
        gameLayer.position = CGPoint(x: size.width, y: 0)
        let gameLayerMove = SKAction.move(by: CGVector(dx: -size.width, dy: 0) , duration: 0.7)
        gameLayerMove.timingMode = .easeOut
        gameLayer.run(gameLayerMove)
    }
    
    func removeAllFruitSprites() {
        fruitsLayer.removeAllChildren()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard let touch = touches.first else { return }
        let location = touch.location(in: fruitsLayer)
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        guard swipeFromColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.location(in: fruitsLayer)
        
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
    
    func trySwapHorizontal(_ horzDelta: Int, vertical vertDelta: Int) {
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
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
