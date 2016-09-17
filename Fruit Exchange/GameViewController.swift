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
    
    @IBOutlet weak var gameOverPanel: UIImageView!
    
    @IBOutlet weak var MovesLabel: UILabel!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLevel(0)
    }
    
    func setupLevel(levelNum: Int) {
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(fileNamed: "GameScene")
        scene.scaleMode = .AspectFill
        
        // Setup the level.
        level = Level(filename: "Level_0")
        scene.level = level
        
        scene.addTiles()
        scene.addHud()
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.hidden = true
        
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
    
    func handleSwipe(swap: Swap) {
        self.view.userInteractionEnabled = false
        level.performSwap(swap)
        level.changeToComplement(swap)
        
        scene.animateSwap(swap) {
            self.scene.changeSprites(swap, completion: self.decrementMoves)
            self.view.userInteractionEnabled = true
        }

    }
    
    func showGameOver() {
        
        scene.animateGameOver() {
            self.gameOverPanel.center.y += self.view.bounds.height
            self.gameOverPanel.hidden = false
            
            self.scene.userInteractionEnabled = false
            UIView.animateWithDuration(0.45, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.CurveEaseOut], animations: {
                self.gameOverPanel.center.y -= self.view.bounds.height
                }, completion: nil)
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
            UIView.animateWithDuration(0.6, delay: 0, options: [.CurveEaseInOut], animations: {
            self.gameOverPanel.center.y += self.view.bounds.height
            }) { (true) in
                self.view.removeGestureRecognizer(self.tapGestureRecognizer)
                self.tapGestureRecognizer = nil
        
                self.gameOverPanel.hidden = true
                self.gameOverPanel.center.y -= self.view.bounds.height
                self.scene.userInteractionEnabled = true
                self.setupLevel(0)
        }

    }
    
    
    func decrementMoves() {
        movesLeft -= 1
        scene.updateMovesLabel(movesLeft)
        
        if level.isCorrectPattern() {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            // Increment the current level, go back to level 1 if the current level
            // is the last one.
            showGameOver()
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
}
