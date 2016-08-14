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
        
        scene = GameScene(fileNamed:"GameScene")
        
        let skView = self.view as! SKView
        scene.scaleMode = .AspectFill
        level = Level(filename: "Level_0")
        scene.level = level
        
        skView.showsFPS = true
        
        skView.showsNodeCount = true
        
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .AspectFill
        
        level = Level(filename: "Level_0")
 
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        skView.presentScene(scene)
        beginGame()
    }
    
    func beginGame() {
        let newFruit = level.createInitialFruit()
        scene.addSpritesForFruit(newFruit)
    }
    
    func handleSwipe(swap: Swap) {
        self.view.userInteractionEnabled = false
        level.performSwap(swap)
        
        scene.animateSwap(swap) {
            self.scene.changeSprites(swap) {
                self.view.userInteractionEnabled = true
            }
            self.view.userInteractionEnabled = true
        }
        
        
        

    }
}
