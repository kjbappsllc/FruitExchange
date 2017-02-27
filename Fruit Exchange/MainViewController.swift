//
//  MainViewController.swift
//  Fruit Exchange
//
//  Created by Mac on 11/16/16.
//  Copyright © 2016 KJB Apps LLC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CircleMenuDelegate {
    
    let items: [(icon: String, color: UIColor)] = [
        ("MenuApple", UIColor(red:255/255, green:82/255, blue:82/255, alpha:1)),
        ("MenuBlueberry", UIColor(red:74/255, green:144/255, blue:266/255, alpha:1)),
        ("MenuBanana", UIColor(red:225/255, green:214/255, blue:81/255, alpha:1)),
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            let button = CircleMenu(
            frame: CGRect(x: self.view.bounds.midX - 25 , y: self.view.bounds.midY + 25, width: 50, height: 50),
            normalIcon:"Playbutton",
            selectedIcon:"Selected",
            buttonsCount: 3,
            duration: 1,
            distance: 95)
            button.backgroundColor = UIColor.lightGray
            button.delegate = self
            button.layer.cornerRadius = button.frame.size.width / 2.0
            self.view.addSubview(button)
        }
        else {
            let button = CircleMenu(
                frame: CGRect(x: self.view.bounds.midX - 50 , y: self.view.bounds.midY + 50, width: 100, height: 100),
                normalIcon:"Playbutton",
                selectedIcon:"Selected",
                buttonsCount: 3,
                duration: 1,
                distance: 175)
            button.backgroundColor = UIColor.lightGray
            button.delegate = self
            button.layer.cornerRadius = button.frame.size.width / 2.0
            self.view.addSubview(button)
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "game") as? GameViewController
        self.present(next!, animated: false, completion: nil)
    }
    

}
