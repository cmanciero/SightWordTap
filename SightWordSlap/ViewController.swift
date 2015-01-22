//
//  ViewController.swift
//  SightWordSlap
//
//  Created by Manciero, Christopher on 1/18/15.
//  Copyright (c) 2015 Christopher Manciero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    @IBOutlet weak var btnPreK: UIButton!
    @IBOutlet weak var btnK: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnPreK.tag = 0
        btnK.tag = 1
        btnFirst.tag = 2
        btnSecond.tag = 3
        btnThird.tag = 4
        btnAll.tag = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playGame(sender: AnyObject) {
        performSegueWithIdentifier("displaySightWords", sender: sender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var view = segue.destinationViewController as SlapViewController
        
        var buttonClicked = sender as UIButton

        // Pass the selected object to the new view controller.
        switch(buttonClicked.tag){
        case 0:
            view.selectedGrade = "prePrimer"
        case 1:
            view.selectedGrade = "primer"
        case 2:
            view.selectedGrade = "firstGrade"
        case 3:
            view.selectedGrade = "secondGrade"
        case 4:
            view.selectedGrade = "thirdGrade"
        case 5:
            view.selectedGrade = "all"
        default:
            view.selectedGrade = "prePrimer"
        }
    }
}

