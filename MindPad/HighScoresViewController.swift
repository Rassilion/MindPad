//
//  HighScoresViewController.swift
//  MindPad
//
//  Created by Deniz Gezgin on 02/01/2018.
//  Copyright © 2018 yagodeniz. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {

    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var survivalLabel: UILabel!
    
    var defaults: UserDefaults = UserDefaults.standard
    
    @IBAction func resetButton(_ sender: Any) {
        defaults.set(0, forKey: "normal")
        defaults.set(0, forKey: "time")
        defaults.set(0, forKey: "survival")
        
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let normalHS = defaults.integer(forKey: "normal")
        let timeHS = defaults.integer(forKey: "time")
        let survivalHS = defaults.integer(forKey: "survival")
        
        normalLabel.text = normalHS != 0 ? "Normal mode: \(normalHS)" : "No highscore for Normal mode"
        timeLabel.text = timeHS != 0 ? "Time Attack mode: \(timeHS)" : "No highscore for Time Attack mode"
        survivalLabel.text = survivalHS != 0 ? "Survival mode: \(survivalHS)" : "No highscore for Survival mode"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
