//
//  ViewController.swift
//  BullsEye
//
//  Created by Sai on 10/30/14.
//  Copyright (c) 2014 Sai. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    var currentSliderValue: Int = 0
    var targetValue: Int = 0;
    var score: Int = 0;
    var round: Int = 0;
    var highscore: Int = 0;
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, forState: .Normal)
        
        let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftImage = UIImage(named: "SliderTrackLeft")
        let trackLeftResizable = trackLeftImage?.resizableImageWithCapInsets(insets)
        
        let trackRightImage = UIImage(named: "SliderTrackRight")
        let trackRightResizable = trackRightImage?.resizableImageWithCapInsets(insets)
        
        slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
        slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
        
        startNewGame()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlert() {
        
        let difference = abs(targetValue - currentSliderValue)
        var points = 100 - difference
        
        var title:String
        
        if difference == 0 {
            title = "Perfect!"
            points += 100
        } else if difference < 5 {
            title = "You almost had it!"
            if difference == 1 {
                points += 50
            }
        } else if difference < 10 {
            title = "Pretty good!"
        } else {
            title = "Not even close!"
        }
        
        var message = "\(points)"
        score += points
        
        if score > highscore {
            highscore = score
            message += "\nNew High Score!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert )
        let action = UIAlertAction(title: "Ok", style: .Default, handler: {
                                                              action in
                                                              self.startNewRound()
                                                              self.updateLabels()
                                                            })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(slider: UISlider){
        currentSliderValue = lroundf(slider.value)
        //println("The current value of slider is: \(currentSliderValue)")
    }
    
    func startNewRound(){
        round++
        targetValue = 1 + Int(arc4random_uniform(100))
        currentSliderValue = 50
        slider.value = Float(currentSliderValue)
        
    }
    
    func updateLabels() {
         targetLabel.text = String(targetValue)
         scoreLabel.text = String(score)
         roundLabel.text = String(round)
         highscoreLabel.text = String(highscore)
    }
    
    func startNewGame() {
        round = 0
        score = 0
        startNewRound()
    }
    
    @IBAction func startOver() {
        startNewGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.layer.addAnimation(transition, forKey: nil)
        
    }


}

