//
//  MainViewController.swift
//  MindPad
//
//  Created by Deniz Gezgin on 29/12/2017.
//  Copyright © 2017 yagodeniz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? ViewController{
            nextViewController.mode = Int32((sender as! UIButton).tag)
        }
    }

}

