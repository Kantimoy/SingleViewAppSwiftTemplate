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
    var timerCount = 60
    
    var eventManager = EventManager()
    var time = Timer()
    
    
    // Labels ...
    @IBOutlet weak var firstLabelView: UILabel!
    @IBOutlet weak var secondLabelView: UILabel!
    @IBOutlet weak var thirdLabelView: UILabel!
    @IBOutlet weak var fourthLabelView: UILabel!
    
    //Button for Next Round.
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBAction func goToNextRound() {
    }
    
    //Label for Shake information.
    @IBOutlet weak var shakeInformation: UILabel!
    
    
    @IBAction func swapFirstAndSecond() {
        swap(&firstLabelView.text, &secondLabelView.text)
    }
    
    @IBAction func swapSecondAndThird() {
        swap(&secondLabelView.text, &thirdLabelView.text)
    }
    
    @IBAction func swapThirdAndFourth() {
        swap(&thirdLabelView.text, &fourthLabelView.text)
    }
    
    
    @IBOutlet weak var firstLabelButton: UIButton!
    @IBOutlet weak var secondLabelDownButton: UIButton!
    @IBOutlet weak var secondLabelUpButton: UIButton!
    @IBOutlet weak var thirdLabelDownButton: UIButton!
    @IBOutlet weak var thirdLabelUpButton: UIButton!
    @IBOutlet weak var fourthLabelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load all the events first.
        eventManager.getAllEvents()
        
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
        var event = eventManager.shuffleEvents()
        
        //Only first 4 options have to shown always out of all event array.
        firstLabelView.text = event[0]
        secondLabelView.text = event[1]
        thirdLabelView.text = event[2]
        fourthLabelView.text = event[3]
        
        //Set different image while button is pressed.
        firstLabelButton.setImage(#imageLiteral(resourceName: "down_full_selected"), for: .highlighted)
        secondLabelDownButton.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        secondLabelUpButton.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        thirdLabelDownButton.setImage(#imageLiteral(resourceName: "down_half_selected"), for: .highlighted)
        thirdLabelUpButton.setImage(#imageLiteral(resourceName: "up_half_selected"), for: .highlighted)
        fourthLabelButton.setImage(#imageLiteral(resourceName: "up_full_selected"), for: .highlighted)
        
        
        //Timer
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownTimer), userInfo: nil, repeats: true)
        
    }
    
    
    //Checks the answer if shake event occurs.
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
        checkUserInput()
        }
    }
    
    
    //Countdown begins from 60secs, at 0 second check.
    @objc func countdownTimer () {
        timerCount -= 1
        nextRoundButton.setTitle(String(timerCount), for: .normal)
        
        if (timerCount == 0) {
            checkUserInput()
        }
    }
    
    
    func checkUserInput() {
        
        time.invalidate()
        
        //If ascending order (Oldest in the top) is true then start next round after 3 seconds.
        if checkForAscendingOrder() {
            score += 1
            shakeInformation.text = "Your Score: \(String(score))"
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: .normal)
            perform(#selector(loadNextRoundAfter), with: nil, afterDelay: 3)
        }
        else {
        //If Answer is wrong, stop the game and show final score after 6 secs.
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail.png"), for: .normal)
            perform(#selector(showFinalScore), with: nil, afterDelay: 6)
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
        
        guard let firstLabelText = firstLabelView.text else { return false }
        guard let secondLabelText = secondLabelView.text else {return false}
        guard let ThirdLabelText = thirdLabelView.text else {return false}
        guard let FourthLabelText = fourthLabelView.text else {return false}
        
        // Check all the events are in ascending order.
        let firstCheck = eventManager.checkEventsInAscendingOrder(inYear: firstLabelText, compare: secondLabelText)
        let secondCheck = eventManager.checkEventsInAscendingOrder(inYear: secondLabelText, compare: ThirdLabelText)
        let thirdCheck = eventManager.checkEventsInAscendingOrder(inYear: ThirdLabelText, compare: FourthLabelText)
        
        // If all option are in ascending order then return true.
        if firstCheck && secondCheck && thirdCheck {
            return true
        } else {
            return false
        }
        
    }
    
    func nextRound() {
        timerCount = 60
        shakeInformation.text = "Shake to complete."
        totalRounds -= 1
        nextRoundButton.setImage(nil, for: .normal)
        
        //If 6 rounds are complete then show Final score.
        if totalRounds == 0 {
            showFinalScore()
        } else {
            startRound()
        }
    }
}

