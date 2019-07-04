//
//  ViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Treehouse on 12/8/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties.
    var score = 0
    var totalRounds = 6
    var timerCount = 15
    
    var displayEvent = DisplayEvents()
    var time = Timer()
    
    
    // Labels ...
    @IBOutlet weak var ViewFirstOption: UILabel!
    @IBOutlet weak var ViewSecondOption: UILabel!
    @IBOutlet weak var ViewThirdOption: UILabel!
    @IBOutlet weak var ViewFourthOption: UILabel!
    
    //Button for Next Round.
    @IBOutlet weak var GoNextRound: UIButton!
    @IBAction func GoToNextRound() {
    }
    
    //Label for Shake information.
    @IBOutlet weak var ShakeInformation: UILabel!
    
    @IBAction func swapFirstAndSecond() {
        swap(&ViewFirstOption.text, &ViewSecondOption.text)
    }
    @IBAction func swapSecondAndThird() {
        swap(&ViewSecondOption.text, &ViewThirdOption.text)
    }
    @IBAction func swapThirdAndFourth() {
        swap(&ViewThirdOption.text, &ViewFourthOption.text)
    }
    
    
    @IBOutlet weak var FirstLabelButton: UIButton!
    @IBOutlet weak var secondLabelDownButton: UIButton!
    @IBOutlet weak var secondLabelUpButton: UIButton!
    @IBOutlet weak var thirdLabelDownButton: UIButton!
    @IBOutlet weak var thirdLabelUpButton: UIButton!
    @IBOutlet weak var fourthLabelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load all the events first.
        displayEvent.getAllEvents()
        
        //Start the game.
        startRound()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Display options.
    func startRound() {
        
        //Shuffle the options that are loaded.
        var event = displayEvent.shuffleEvents()
        
        //Only first 4 options have to shown always out of all event array.
        ViewFirstOption.text = event[0]
        ViewSecondOption.text = event[1]
        ViewThirdOption.text = event[2]
        ViewFourthOption.text = event[3]
        
        FirstLabelButton.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted)
        secondLabelDownButton.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        secondLabelUpButton.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        thirdLabelDownButton.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        thirdLabelUpButton.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        fourthLabelButton.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted)
        
        
        //Timer
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
        
    }
    
    
    //Checks the answer if shake event occurs.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        check()
    }
    
    
    //Countdown begins from 60secs, at 0 second check.
    @objc func action () {
        timerCount -= 1
        GoNextRound.setTitle(String(timerCount), for: .normal)
        
        if (timerCount == 0) {
            check()
        }
    }
    
    
    func check() {
        
        time.invalidate()
        
        //Check for ascending order and start next round.
        if checkForAscendingOrder() {
            score += 1
            ShakeInformation.text = "Your Score: \(String(score))"
            GoNextRound.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
            perform(#selector(loadNextRoundAfter), with: nil, afterDelay: 3)
        }
        else {
        //If Answer is wrong, stop the game and show final score.
            GoNextRound.setImage(#imageLiteral(resourceName: "next_round_fail.png"), for: .normal)
            perform(#selector(showFinalScore), with: nil, afterDelay: 8)
        }
    }
    
    @objc func loadNextRoundAfter() {
        nextRound()
    }
    
    @objc func showFinalScore() {
        performSegue(withIdentifier: "finalScore", sender: nil)
    }
    
    //Pass the score to FinalScore View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? FinalScoreViewController {
        destinationViewController.score = self.score
        }
    }
    
    
    // Check in Ascending order.
    func checkForAscendingOrder() -> Bool {
        
        guard let firstLabelText = ViewFirstOption.text else { return false }
        guard let secondLabelText = ViewSecondOption.text else {return false}
        guard let ThirdLabelText = ViewThirdOption.text else {return false}
        guard let FourthLabelText = ViewFourthOption.text else {return false}
        
        // Check all the events are in ascending order.
        let firstCheck = displayEvent.checkEventsInAscendingOrder(inYear: firstLabelText, compare: secondLabelText)
        let secondCheck = displayEvent.checkEventsInAscendingOrder(inYear: secondLabelText, compare: ThirdLabelText)
        let thirdCheck = displayEvent.checkEventsInAscendingOrder(inYear: ThirdLabelText, compare: FourthLabelText)
        
        // If all option are in ascending order then return true.
        if firstCheck && secondCheck && thirdCheck {
            return true
        } else {
            return false
        }
        
    }
    
    func nextRound() {
        timerCount = 60
        ShakeInformation.text = "Shake to complete."
        totalRounds -= 1
        GoNextRound.setImage(nil, for: .normal)
        
        //If 6 rounds are complete then show Final score.
        if totalRounds == 0 {
            showFinalScore()
        } else {
            startRound()
        }
    }
}

