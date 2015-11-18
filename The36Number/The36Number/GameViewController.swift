//
//  GameViewController.swift
//  The36Number
//
//  Created by Nantinee Tulyanon on 11/19/14.
//  Copyright (c) 2014 mabaw. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData


var scene: GameScene!

class GameViewController: UIViewController {

    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var nextNumber: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var nextTargetNo: UInt32 = 1
    var maxNo: UInt32 = 36
    var randomNumberArray: Array<UInt32>!
    var buttonArray: Array<UIButton>!
    var startTime: NSDate!
    var usedTime: NSTimeInterval!
    var level: UInt32!
    var managedContext: NSManagedObjectContext!
    let numberAreaWidth: UInt32 = 320
    
    var score = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size,level: level)
        scene.scaleMode = .AspectFill
        scene.updateTime = didUpdateTime
        
        
        // game start
        initGame()
        
        // Present the scene.
        skView.presentScene(scene)

   }
    
    func getButtonCoordinate(idx:UInt32) -> (x:UInt32,y:UInt32,width:UInt32) {
   
        let numPerRow = sqrt(Double(maxNo))
        let buttonWidth = Double(numberAreaWidth)/numPerRow
        
        let row = floor(Double(idx-1) / numPerRow)
        let col = floor((Double(idx-1) % numPerRow))
        
        return (UInt32(row * buttonWidth ),UInt32(col * buttonWidth) ,UInt32(buttonWidth))
    }
    
    func initGame(){
        scene.gameStart = true
        nextTargetNo = 1
        nextNumber.text = String(nextTargetNo)
        result.text = "Hurry up!"

        randomNumberArray = Array<UInt32>()
        buttonArray = Array<UIButton>()
        
        
        for index in 1...maxNo{
            var repeatNumber: Bool = true
            var randomInt: UInt32
            randomInt = UInt32(arc4random_uniform(maxNo)) + 1
            while ( repeatNumber && randomNumberArray.count > 0) {
                    repeatNumber = false
                    randomInt = UInt32(arc4random_uniform(maxNo)) + 1
                    for j in 0...randomNumberArray.count-1 {
                        if(randomNumberArray[j] == randomInt){
                            repeatNumber = true
                        }
                    }
            }
            let button = UIButton(type: UIButtonType.System) as UIButton
            button.setTitle(String(randomInt), forState: UIControlState.Normal)
            let buttonXY = getButtonCoordinate(index)
            button.frame = CGRectMake(CGFloat(buttonXY.y) + 2.5 , CGFloat(buttonXY.x)  + 2.5, CGFloat(buttonXY.width-5), CGFloat(buttonXY.width-5))
            button.backgroundColor = UIColor.whiteColor()
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = Int(randomInt)
            button.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.view.addSubview(button)
            buttonArray.append(button)
            randomNumberArray.append(randomInt)
        }
        
    

        startTime = NSDate()
        usedTime = nil
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        numberClick(sender.tag)
        print(sender.tag)
    }
    
    func setLevel(level:UInt32){
        maxNo = (level + 1) * (level + 1)
        self.level = level
    }
    
    func numberClick (number: Int){
        if(UInt32(number) == nextTargetNo) {
            nextTargetNo++
            nextNumber.text = String(nextTargetNo)
            for i in 0...buttonArray.count-1 {
                if(buttonArray[i].tag == number){
                    buttonArray[i].removeFromSuperview()
                }
            }
        }
        
        if (nextTargetNo > UInt32(maxNo)) {
            endGame()
        }
    }
    
    func endGame(){
        result.text = "Found You"
        nextNumber.text = ""
        scene.gameStart = false
       // saveScore(level,time: Float(usedTime))
    }
    
    func saveScore(level: UInt32,time: Float) {
        //fetch previous score to compare with this time score
        var levelRecorded: Bool = false
        let fetchRequest = NSFetchRequest(entityName: "Score")
        do{
            let fetchResults = try  managedContext!.executeFetchRequest(fetchRequest) as? [Score]
            if (fetchResults!.count > 0) {
                for i in 0...fetchResults!.count-1 {
                    if (fetchResults![i].level == Int16(level) ){
                        levelRecorded = true
                        if(fetchResults![i].score > time) {
                            fetchResults![i].score = time
                           /* var error: NSError?
                            if !managedContext.save(&error) {
                                print("Could not save \(error), \(error?.userInfo)")
                            }*/
                            result.text = "New Best Time"
                            return
                        }
                    }
                }
            }

        }
        catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        if(levelRecorded == false)
        {
            let entity =  NSEntityDescription.entityForName("Score", inManagedObjectContext: managedContext)
            let score = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
            score.setValue(Int(level), forKey: "level")
            score.setValue(time, forKey: "score")
            /*
            var error: NSError?
            if !managedContext.save(&error) {
                print("Could not save \(error), \(error?.userInfo)")
            }*/
        }
    }
    
    @IBAction func screenTap(sender: UITapGestureRecognizer) {
        if (scene.gameStart == false){
            self.dismissViewControllerAnimated(false, completion: nil)
        }

    }
    
    func didUpdateTime(){
        let diffTime = startTime.timeIntervalSinceNow * -1
        var t = diffTime - floor(diffTime)
        t = t * 1000
        t = floor(t)
        time.text = String(Int16(diffTime)) + "." + String(Int(t))
        usedTime = diffTime
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
