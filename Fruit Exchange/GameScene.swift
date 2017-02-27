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
    private var grid: Grid!
    private var spriteSize: CGFloat = 0
    private var movesLabel = SKLabelNode()
    
    fileprivate var swipeFromColumn: Int?
    fileprivate var swipeFromRow: Int?
    
    
    private let gameLayer = SKNode()
    private let hudLayer = SKNode()
    private let fruitsLayer = SKNode()
    private let tilesLayer = SKNode()
    
    var level: Level {
        get {
            return _level
        }
        set {
            _level = newValue
        }
    }
    
    var viewOnlyGrid: Grid {
        get {
            return grid
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
        
        grid.level = level
        grid.addChild(tilesLayer)
        grid.addChild(fruitsLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
    }
    
    func updateMovesLabel(_ number: Int) {
        movesLabel.text = String(number)
    }
    
    func getGridSpriteSizes(gridSize: Int) -> CGFloat {
        var sizing = CGFloat()
        switch(gridSize) {
        case 2:
            sizing = 200
        case 3:
            sizing = 166.67
        case 4:
            sizing = 125
        case 5:
            sizing = 100
        case 6:
            sizing = 83.3
        default:
            sizing = 0.0
        }
        
        return sizing
    }
    
    func addSpritesForFruit(_ fruits: Set<Fruit>) {
        for fruit in fruits {
            let sprite = SKSpriteNode(imageNamed: fruit.fruitType.spriteName)
            sprite.position = grid.gridPosition(row: fruit.row, col: fruit.column)
            sprite.size = CGSize(width: spriteSize - 20, height: spriteSize - 20)
            fruitsLayer.addChild(sprite)
            fruit.sprite = sprite
        }
    }
    
    func addTiles() {
        for row in 0..<level.gridSize {
            for column in 0..<level.gridSize{
                var tileNode = SKSpriteNode()
                if level.tileAtColumn(column, row: row) != nil {
                    if (column % 2 == 0 && row % 2 == 0) || (column % 2 != 0 && row % 2 != 0) {
                        tileNode = SKSpriteNode(imageNamed: "Tile2")
                    }
                    else {
                        tileNode = SKSpriteNode(imageNamed: "Tile1")
                    }
                    tileNode.size = CGSize(width: spriteSize - 10, height: spriteSize - 10)
                    tileNode.position = grid.gridPosition(row: column, col: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    
    func setUpGrid() {
        spriteSize = getGridSpriteSizes(gridSize: level.gridSize)
        if let griding = Grid(blockSize: spriteSize, rows:level.gridSize, cols:level.gridSize) {
            grid = griding
            grid.spriteSize = spriteSize
            gameLayer.addChild(grid)
        }
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
            
            spriteA.position = grid.gridPosition(row: swap.fruitA.row, col: swap.fruitA.column)
            spriteA.size = CGSize(width: spriteSize - 20, height: spriteSize - 20)
            fruitsLayer.addChild(spriteA)
            spriteA.run(SKAction.sequence([scaleA, SKAction.scale(to: 1.0, duration: 0.1)]))
            
            let scaleB = SKAction.scale(to: 1.05, duration: 0.1)
            spriteB.removeFromParent()
            spriteB = SKSpriteNode(imageNamed: swap.fruitB.fruitType.spriteName)
            swap.fruitB.sprite = spriteB
            
            spriteB.position = grid.gridPosition(row: swap.fruitB.row, col:swap.fruitB.column)
            spriteB.size = CGSize(width: spriteSize - 20, height: spriteSize - 20)
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
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
