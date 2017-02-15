//
//  GameViewController.swift
//  Fruit Exchange
//
//  Created by Mac on 8/10/16.
//  Copyright (c) 2016 KJB Apps LLC. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var level: Level!
    
    var movesLeft = 0
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLevel(0)
    }
    
    func setupLevel(_ levelNum: Int) {
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(fileNamed: "GameScene")
        scene.scaleMode = .aspectFill
        
        // Setup the level.
        level = Level(filename: "Level_0")
        scene.level = level
        
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        // Present the scene.
        skView.presentScene(scene)
        
        // Start the game.
        beginGame()
    }
    
    func beginGame() {
        movesLeft = level.maximumMoves
        scene.updateMovesLabel(movesLeft)
        scene.animateBeginGame()
        let newFruit = level.createInitialFruit()
        scene.removeAllFruitSprites()
        scene.addSpritesForFruit(newFruit)
    }
    
    func handleSwipe(_ swap: Swap) {
        self.view.isUserInteractionEnabled = false
        level.performSwap(swap)
        level.changeToComplement(swap)
        
        scene.animateSwap(swap) {
            self.scene.changeSprites(swap){
                self.view.isUserInteractionEnabled = true
            }
        }

    }
}
