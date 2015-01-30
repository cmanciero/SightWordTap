//
//  SlapViewController.swift
//  SightWordSlap
//
//  Created by Manciero, Christopher on 1/20/15.
//  Copyright (c) 2015 Christopher Manciero. All rights reserved.
//

import UIKit
import AVFoundation

class SlapViewController: UIViewController, AVAudioPlayerDelegate, TimesUpDelegate {
    var selectedGrade : String?
    var wordToSlap : String?
    var listOfWords = [String]()
    var myPlayer = AVAudioPlayer()
    var wordRec : NSURL?
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var countdown : Float = 5.00
    
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var btnFirstWord: UIButton!
    @IBOutlet weak var btnSecondWord: UIButton!
    @IBOutlet weak var btnThirdWord: UIButton!
    @IBOutlet weak var displayTimer: UILabel!
    
    @IBAction func replayWord(sender: AnyObject) {
        // replay the word
        replay()
    }
    
    @IBAction func goBackToHome(sender: AnyObject) {
        timer.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Check if word slapped is right
    @IBAction func checkWord(sender: UIButton) {
        let wordSlapped = sender.titleLabel!.text
        
        if wordSlapped == wordToSlap{
            // play good job sound
            
            if(selectedGrade! == "secondGrade" || selectedGrade! == "thirdGrade" || selectedGrade! == "all"){
                // stop timer and reset countdown
                timer.invalidate()
                countdown = 5.00
            
                // reset timer label
                displayTimer.text = "5.00"
            }
            
            // set next words
            setWordsToButtons()
        } else {
            // play wrong sound
            // list of sounds - http://iphonedevwiki.net/index.php/AudioServices
            // AudioServicesPlaySystemSound(1105)
            
            var soundPath = NSBundle.mainBundle().pathForResource("wrong", ofType: "wav")
            var sound = NSURL(fileURLWithPath: soundPath!)
            self.prepareYourSound(sound!)
            self.myPlayer.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // display label only if user selects second grade or third grade
        if(selectedGrade! == "secondGrade" || selectedGrade! == "thirdGrade" || selectedGrade! == "all"){
            displayTimer.hidden = false
        }
        
        // read from plist file to get the sight words for selected grade
        if let path = NSBundle.mainBundle().pathForResource("sightWords", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                if selectedGrade! == "all"{
                    for (grade, words) in dict{
                        for word in words as [String]{
                            listOfWords.append(word)
                        }
                    }
                } else {
                    if let arr = dict[selectedGrade!]! as? [String] {
                        listOfWords = arr
                    }
                }
                
                // set the words to the buttons
                setWordsToButtons()
            }
        }
    }
    
    // replay the word
    func replay(){
        timer.invalidate()
        countdown = 5.00
        
        // reset timer label
        displayTimer.text = "5.00"
        
        // play the word again
        playSound()
    }
    
    // tryAgain delegate method from TimesUpViewController (TimesUpDelegate)
    func tryAgain() {
        replay()
    }
    
    // get ready to play word audio
    func prepareYourSound(soundFile:NSURL) {
        myPlayer = AVAudioPlayer(contentsOfURL: soundFile, error: nil)
        myPlayer.delegate = self
        myPlayer.prepareToPlay()
    }
    
    // when audio file stops playing
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // start timer only if user selects second grade or third grade
        if(selectedGrade! == "secondGrade" || selectedGrade! == "thirdGrade" || selectedGrade! == "all"){
            startTimer()
        }
        
        // enable the words after the word is played
        btnFirstWord.enabled = true
        btnSecondWord.enabled = true
        btnThirdWord.enabled = true
    }
    
    // play audio of word to slap
    func playSound(){
        btnFirstWord.enabled = false
        btnSecondWord.enabled = false
        btnThirdWord.enabled = false
        
        // play word
        var path = wordToSlap!
        var soundPath = NSBundle.mainBundle().pathForResource(path, ofType: "m4a")
        var sound = NSURL(fileURLWithPath: soundPath!)
        self.prepareYourSound(sound!)
        self.myPlayer.play()
    }

    // randomize passed in array
    func indexRandom(arrayToRandom: [AnyObject]) -> [Int] {
        var newIndex = 0
        var shuffledIndex:[Int] = []
        while shuffledIndex.count < arrayToRandom.count {
            newIndex = Int(arc4random_uniform(UInt32(arrayToRandom.count)))
            if !(find(shuffledIndex,newIndex) > -1 ) {
                shuffledIndex.append(newIndex)
            }
        }
        return  shuffledIndex
    }
    
    // set the sight words to the buttons
    func setWordsToButtons(){
        // randomize list of words
        let randomIndexList = indexRandom(self.listOfWords)
        
        // set the 3 words
        let firstWord = self.listOfWords[randomIndexList[0]]
        let secondWord = self.listOfWords[randomIndexList[1]]
        let thirdWord = self.listOfWords[randomIndexList[2]]

        // assign the words to the buttons
        btnFirstWord.setTitle(firstWord, forState: nil)
        btnSecondWord.setTitle(secondWord, forState: nil)
        btnThirdWord.setTitle(thirdWord, forState: nil)
        
        var colors : [UIColor] = [UIColor.blueColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.magentaColor(), UIColor.orangeColor(), UIColor.redColor(), UIColor.yellowColor()]
        
        let randomColorList = indexRandom(colors)
        
        btnFirstWord.setTitleColor(colors[randomColorList[0]], forState: nil)
        btnSecondWord.setTitleColor(colors[randomColorList[1]], forState: nil)
        btnThirdWord.setTitleColor(colors[randomColorList[2]], forState: nil)
        
        // set the word to find
        let wordToMatch = Int(arc4random_uniform(3));
        switch(wordToMatch){
        case 0:
            wordToSlap = firstWord
        case 1:
            wordToSlap = secondWord
        case 2:
            wordToSlap = thirdWord
        default:
            wordToSlap = firstWord
        }
        
        // play sound for selected word
        playSound()
    }
    
    // update the label for countdown
    func updateTime(){
        countdown = countdown - 0.01

        if(countdown <= 0.00){
            displayTimer.text = ""
            timer.invalidate()
            countdown = 5.00

            performSegueWithIdentifier("timesUp", sender: nil)
        } else {
            displayTimer.text = NSString(format: "%.2F", countdown)

            self.navigationItem.title = NSString(format: "%.2F", countdown)
        }
    }
    
    // start countdown timer
    func startTimer(){
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "timesUp"{
            var timesUp = segue.destinationViewController as TimesUpViewController
            timesUp.delegate = self
        }
    }

}
