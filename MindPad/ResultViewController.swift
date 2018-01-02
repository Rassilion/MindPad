//
//  ResultViewController.swift
//  MindPad
//
//  Created by Deniz Gezgin on 29/12/2017.
//  Copyright © 2017 yagodeniz. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var score:Int = 0
    var totalTime:Int = 0
    var mode:Int32 = 0

    @IBOutlet weak var timeLLabel: UILabel!
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var timeLabel: SACountingLabel!
    @IBOutlet weak var scoreLabel: SACountingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        timeLabel.countFrom(fromValue: 0, to: Float(totalTime), withDuration: 1.0, andAnimationType: .EaseIn, andCountingType: .Int)
        scoreLabel.countFrom(fromValue: 0, to: Float(score), withDuration: 1.0, andAnimationType: .EaseIn, andCountingType: .Int)
        let defaults = UserDefaults.standard
        if(mode==1){
            defaults.set(score, forKey: "normal")
            titleLabel.title = "Normal Mode"
        }else if(mode==2){
            defaults.set(score, forKey: "time")
            titleLabel.title = "Time Attack Mode"
            timeLabel.killTimer()
            timeLabel.text=" "
            timeLLabel.text=" "	
        }else if(mode==3){
            defaults.set(score, forKey: "survival")
            titleLabel.title = "Survival Mode"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func shareAction(_ sender: Any) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [img as Any], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "againSegue"{
            if let nextViewController = segue.destination as? ViewController{
                nextViewController.initGam = true
                nextViewController.mode = mode
            }
        }
    }

}
