//
//  ViewController.swift
//  The36Number
//
//  Created by Nantinee Tulyanon on 11/24/14.
//  Copyright (c) 2014 mabaw. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

var viewScene:ViewScene!

class ViewController: UIViewController {
    var level:Int!
    var managedContext: NSManagedObjectContext!
    
    
    @IBOutlet weak var cheeseScore: UILabel!
    @IBOutlet weak var peanutScore: UILabel!
    @IBOutlet weak var shiroScore: UILabel!
    @IBOutlet weak var kingScore: UILabel!
    
    
    @IBAction func didTouchLevel1(sender: UIButton) {
        level = 3
    }
    
    @IBAction func didClickLevel2(sender: UIButton) {
        level = 4
    }
    
    @IBAction func didClickLevel3(sender: UIButton) {
        level = 5
    }
    
    @IBAction func didClickLevel4(sender: UIButton) {
        level = 6
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ToGame") {
            let gameVC:GameViewController = segue.destinationViewController as! GameViewController

            gameVC.managedContext = managedContext
            gameVC.setLevel(UInt32(level))
        }
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        print("Tap!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        viewScene = ViewScene(size: skView.bounds.size)
        viewScene.scaleMode = .AspectFill
        viewScene.updateScore = loadBestScore
        
       
        
        //load CoreData
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contxt : NSManagedObjectContext = appDel.managedObjectContext!
        managedContext = contxt
        
        loadBestScore()
        
        // Present the scene.
        skView.presentScene(viewScene)
    }
    
    func loadBestScore() {
        let fetchRequest = NSFetchRequest(entityName: "Score")
        do {
            let fetchResults = try managedContext!.executeFetchRequest(fetchRequest) as? [Score]
            
            if (fetchResults!.count > 0) {
                for i in 0...fetchResults!.count-1 {
                    let scoreTxt = NSString(format: "%.2f", fetchResults![i].score)
                    if (fetchResults![i].level == 3 ){
                        cheeseScore.text = scoreTxt as String
                    } else if(fetchResults![i].level == 4 ){
                        peanutScore.text = scoreTxt  as String
                    } else if(fetchResults![i].level == 5 ){
                        shiroScore.text = scoreTxt as String
                    } else if(fetchResults![i].level == 6 ){
                        kingScore.text = scoreTxt as String
                    }
                    
                }
            }

        }
        catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
            
        }
           }
    
    @IBAction func didPressPeanut(sender: UIButton) {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}