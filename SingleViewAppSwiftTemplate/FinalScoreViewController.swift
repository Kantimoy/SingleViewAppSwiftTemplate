//
//  FinalScoreViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Kantimoy Sur on 2019-07-02.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit

class FinalScoreViewController: UIViewController {
    
    var score = 0
    var totalRounds = 6
    
    @IBOutlet weak var FinalScore: UILabel!
    
    
    @IBAction func PlayAgain() {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FinalScore.text = "\(String(score))/\(totalRounds)"
    
    }
}
