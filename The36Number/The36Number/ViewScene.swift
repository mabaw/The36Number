//
//  ViewScene.swift
//  The36Number
//
//  Created by Nantinee Tulyanon on 11/30/14.
//  Copyright (c) 2014 mabaw. All rights reserved.
//

import SpriteKit
class ViewScene: SKScene {
    var updateScore:(() -> ())?

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "menubg")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
    }
    
    override func update(currentTime: CFTimeInterval) {
        updateScore?()
    }

}