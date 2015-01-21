//
//  ViewController.swift
//  SightWordSlap
//
//  Created by Manciero, Christopher on 1/18/15.
//  Copyright (c) 2015 Christopher Manciero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnPreSchool: UIButton!
    @IBOutlet weak var btnKindergarten: UIButton!
    @IBOutlet weak var btnFirstGrade: UIButton!
    @IBOutlet weak var btnSecondGrade: UIButton!
    @IBOutlet weak var btnThirdGrade: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup tag to easily identify the clicked button
        btnPreSchool.tag = 1;
        btnKindergarten.tag = 2;
        btnFirstGrade.tag = 3;
        btnSecondGrade.tag = 4;
        btnThirdGrade.tag = 5;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navigateToScreen(sender: UIButton) {
        performSegueWithIdentifier("displaySightWords", sender: sender)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        var view = segue.destinationViewController as SlapViewController
        
        // Pass the selected object to the new view controller.
        switch(sender!.tag){
        case 1:
            view.selectedGrade = "prePrimer"
        case 2:
            view.selectedGrade = "primer"
        case 3:
            view.selectedGrade = "firstGrade"
        case 4:
            view.selectedGrade = "secondGrade"
        case 5:
            view.selectedGrade = "thirdGrade"
        default:
            view.selectedGrade = "prePrimer"
        }
    }
}

