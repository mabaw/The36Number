//
//  GameScene.swift
//  The36Number
//
//  Created by Nantinee Tulyanon on 11/19/14.
//  Copyright (c) 2014 mabaw. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var updateTime:(() -> ())?
    var gameStart: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    init(size: CGSize,level: UInt32) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        var character: SKSpriteNode!
        
        if(level == 3){
            character = SKSpriteNode(imageNamed:  "mouse")
            character.size = CGSize(width: 168,height: 160)
            character.position = CGPoint(x: 52, y: -96)
            character.anchorPoint = CGPoint(x: 0, y: 1.0)
        } else if (level == 4){
            character = SKSpriteNode(imageNamed:  "bear_normal")
            character.size = CGSize(width: 234,height: 252)
            character.position = CGPoint(x: 29, y: -9)
            character.anchorPoint = CGPoint(x: 0, y: 1.0)
        } else if (level == 5){
            character = SKSpriteNode(imageNamed:  "mouse_cr")
            character.size = CGSize(width: 168,height: 180)
            character.position = CGPoint(x: 52, y: -86)
            character.anchorPoint = CGPoint(x: 0, y: 1.0)
        } else if (level == 6){
            character = SKSpriteNode(imageNamed:  "bearColor")
            character.size = CGSize(width: 234,height: 252)
            character.position = CGPoint(x: 29, y: -9)
            character.anchorPoint = CGPoint(x: 0, y: 1.0)
        }
        
        addChild(character)
        

    }

      
    override func update(currentTime: CFTimeInterval) {
        if(gameStart){
            updateTime?()
        }
    }
}
