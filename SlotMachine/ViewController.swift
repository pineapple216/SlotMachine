//
//  ViewController.swift
//  SlotMachine
//
//  Created by Koen Hendriks on 06/10/14.
//  Copyright (c) 2014 Koen Hendriks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Containers
    var firstContainer: UIView!
    var secondContainer: UIView!
    var thirdContainer: UIView!
    var fourthContainer: UIView!
    
    // Constants
    let kMarginForView:CGFloat = 10.0
    let kMarginForSlot:CGFloat = 2.0
    
    let kSixth:CGFloat = 1.0/6.0
    let kThird:CGFloat = 1.0/3.0
    let kHalf:CGFloat = 1.0/2.0
    let kEighth:CGFloat = 1.0/8.0
    
    let kNumberOfContainers = 3
    let kNumberOfSlots = 3
    
    // Information Labels
    var creditsLabel: UILabel!
    var betLabel: UILabel!
    var winnerPaidLabel: UILabel!
    
    var creditsTitleLabel: UILabel!
    var betTitleLabel: UILabel!
    var winnerPaidTitleLabel: UILabel!
    
    // Buttons in fourth container
    var resetButton: UIButton!
    var betOneButton: UIButton!
    var betMaxButton: UIButton!
    var spinButton: UIButton!
    
    var slots:[[Slot]] = []
    
    // Stats
    var credits = 0
    var currentBet = 0
    var winnings = 0
    
    
    // Top Container
    var titleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupContainerViews()
        
        setupFirstContainer(self.firstContainer)
        setupThirdContainer(self.thirdContainer)
        setupFourthContainer(self.fourthContainer)
        
        hardReset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    
    func resetButtonPressed(button:UIButton){
        println("resetButtonPressed ")
        hardReset()
    }
    
    func betOneButtonPressed(button:UIButton){
        if credits <= 0{
            showAlertWithText(header: "No more credits", message: "Reset Game")
        }
        else{
            if currentBet < 5{
                currentBet += 1
                credits -= 1
                updateMainView()
            }
            else{
                showAlertWithText(message: "You can only bet 5 credits at a time!")
            }
        }
    }
    
    func betMaxButtonPressed (button: UIButton) {
        
        if credits <= 5{
            showAlertWithText(header: "Not enough credits", message: "Bet Less")
        }
        else{
            if currentBet < 5{
                var creditsToBetMax = 5 - currentBet
                credits -= creditsToBetMax
                currentBet += creditsToBetMax
                updateMainView()
            }
            else{
                showAlertWithText(message: "You can only bet 5 credits at a time")
            }
        }
    }
    
    // Remove existing slot imageviews and
    // generate a whole new set of imageViews each time we press the spin button
    func spinButtonPressed (button: UIButton) {
        removeSlotImageViews()
        
        slots = Factory.createSlots()
        setupSecondContainer(self.secondContainer)
        
        // Implement the SlotBrain class for keeping track of the scores
        var winningsMultiplier = SlotBrain.computeWinnings(slots)
        
        winnings = winningsMultiplier * currentBet
        credits += winnings
        currentBet = 0
        updateMainView()
    }
    
    
    func setupContainerViews(){
        self.firstContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, self.view.bounds.origin.y, self.view.bounds.width - (kMarginForView * 2) , self.view.bounds.height * kSixth))
        
        self.firstContainer.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.firstContainer)
        
        self.secondContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, firstContainer.frame.height, self.view.bounds.width - kMarginForView * 2, self.view.bounds.height * (3 * kSixth)))
        self.secondContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.secondContainer)
        
        self.thirdContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, firstContainer.frame.height + secondContainer.frame.height, self.view.bounds.width - kMarginForView * 2, self.view.bounds.height * kSixth))
        self.thirdContainer.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.thirdContainer)
        
        self.fourthContainer = UIView(frame: CGRectMake(self.view.bounds.origin.x + kMarginForView, firstContainer.frame.height + secondContainer.frame.height + thirdContainer.frame.height, self.view.bounds.width - kMarginForView * 2, self.view.bounds.height * kSixth))
        self.fourthContainer.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.fourthContainer)
        
    }
    
    func setupFirstContainer(containerView:UIView){
        self.titleLabel = UILabel()
        self.titleLabel.text = "Super Slots"
        self.titleLabel.textColor = UIColor.yellowColor()
        self.titleLabel.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        self.titleLabel.sizeToFit()
        self.titleLabel.center = containerView.center
        
        containerView.addSubview(titleLabel)
    }

    func setupSecondContainer(containerView:UIView){
        for var containerNumber = 0; containerNumber < kNumberOfContainers; ++containerNumber{
            for var slotNumber = 0; slotNumber < kNumberOfSlots; ++slotNumber{
                
                var slot:Slot
                // Create 9 different imageViews to create all the slots
                var slotImageView = UIImageView()
                
                if slots.count != 0{
                    let slotContainer = slots[containerNumber]
                    slot = slotContainer[slotNumber]
                    slotImageView.image = slot.image
                }
                else{
                    slotImageView.image = UIImage(named: "Ace")
                }
                
                slotImageView.backgroundColor = UIColor.yellowColor()
                slotImageView.frame = CGRectMake(containerView.bounds.origin.x + (containerView.bounds.size.width * CGFloat(containerNumber) * kThird), containerView.bounds.origin.y + (containerView.bounds.size.height * CGFloat(slotNumber) * kThird), containerView.bounds.width * kThird - kMarginForSlot, containerView.bounds.height * kThird - kMarginForSlot)
                
                containerView.addSubview(slotImageView)
            }
        }
    }
    
    func setupThirdContainer(containerView:UIView){
        self.creditsLabel = UILabel()
        self.creditsLabel.text = "000000"
        self.creditsLabel.textColor = UIColor.redColor()
        self.creditsLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.creditsLabel.sizeToFit()
        self.creditsLabel.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird)
        self.creditsLabel.textAlignment = NSTextAlignment.Center
        self.creditsLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.creditsLabel)
        
        self.betLabel = UILabel()
        self.betLabel.text = "0000"
        self.betLabel.textColor = UIColor.redColor()
        self.betLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.betLabel.sizeToFit()
        self.betLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird)
        self.betLabel.textAlignment = NSTextAlignment.Center
        self.betLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.betLabel)
        
        self.winnerPaidLabel = UILabel()
        self.winnerPaidLabel.text = "000000"
        self.winnerPaidLabel.textColor = UIColor.redColor()
        self.winnerPaidLabel.font = UIFont(name: "Menlo-Bold", size: 16)
        self.winnerPaidLabel.sizeToFit()
        self.winnerPaidLabel.center = CGPointMake(containerView.frame.width * kSixth * 5, containerView.frame.height * kThird)
        self.winnerPaidLabel.textAlignment = NSTextAlignment.Center
        self.winnerPaidLabel.backgroundColor = UIColor.darkGrayColor()
        containerView.addSubview(self.winnerPaidLabel)
        
        self.creditsTitleLabel = UILabel()
        self.creditsTitleLabel.text = "Credits"
        self.creditsTitleLabel.textColor = UIColor.blackColor()
        self.creditsTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.creditsTitleLabel.sizeToFit()
        self.creditsTitleLabel.center = CGPointMake(containerView.frame.width * kSixth, containerView.frame.height * kThird * 2)
        containerView.addSubview(self.creditsTitleLabel)
        
        self.betTitleLabel = UILabel()
        self.betTitleLabel.text = "Bet"
        self.betTitleLabel.textColor = UIColor.blackColor()
        self.betTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.betTitleLabel.sizeToFit()
        self.betTitleLabel.center = CGPointMake(containerView.frame.width * kSixth * 3, containerView.frame.height * kThird * 2)
        containerView.addSubview(self.betTitleLabel)
        
        self.winnerPaidTitleLabel = UILabel()
        self.winnerPaidTitleLabel.text = "Winner Paid"
        self.winnerPaidTitleLabel.textColor = UIColor.blackColor()
        self.winnerPaidTitleLabel.font = UIFont(name: "AmericanTypewriter", size: 14)
        self.winnerPaidTitleLabel.sizeToFit()
        self.winnerPaidTitleLabel.center = CGPointMake(containerView.frame.width * 5 * kSixth, containerView.frame.height * 2 * kThird)
        containerView.addSubview(self.winnerPaidTitleLabel)
    }
    
    func setupFourthContainer(containerView:UIView){
        self.resetButton = UIButton()
        self.resetButton.setTitle("Reset", forState: UIControlState.Normal)
        self.resetButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.resetButton.backgroundColor = UIColor.lightGrayColor()
        self.resetButton.sizeToFit()
        self.resetButton.center = CGPointMake(containerView.frame.width * kEighth, containerView.frame.height * kHalf)
        self.resetButton.addTarget(self, action: "resetButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.resetButton)
        
        self.betOneButton = UIButton()
        self.betOneButton.setTitle("Bet One", forState: UIControlState.Normal)
        self.betOneButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betOneButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betOneButton.backgroundColor = UIColor.greenColor()
        self.betOneButton.sizeToFit()
        self.betOneButton.center = CGPoint(x: containerView.frame.width * 3 * kEighth, y: containerView.frame.height * kHalf)
        self.betOneButton.addTarget(self, action: "betOneButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betOneButton)
        
        self.betMaxButton = UIButton()
        self.betMaxButton.setTitle("BetMax", forState: UIControlState.Normal)
        self.betMaxButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.betMaxButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.betMaxButton.backgroundColor = UIColor.redColor()
        self.betMaxButton.sizeToFit()
        self.betMaxButton.center = CGPoint(x: containerView.frame.width * 5 * kEighth, y: containerView.frame.height * kHalf)
        self.betMaxButton.addTarget(self, action: "betMaxButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.betMaxButton)
        
        self.spinButton = UIButton()
        self.spinButton.setTitle("Spin", forState: UIControlState.Normal)
        self.spinButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        self.spinButton.titleLabel?.font = UIFont(name: "Superclarendon-Bold", size: 12)
        self.spinButton.backgroundColor = UIColor.greenColor()
        self.spinButton.sizeToFit()
        self.spinButton.center = CGPoint(x: containerView.frame.width * 7 * kEighth, y: containerView.frame.height * kHalf)
        self.spinButton.addTarget(self, action: "spinButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(self.spinButton)
        
    }
    
    func removeSlotImageViews(){
        // Check is secondContainer exists
        if self.secondContainer != nil{
            let container: UIView? = self.secondContainer
            // Check is secondContainer has subViews
            let subViews: Array? = container!.subviews
            for view in subViews!{
                // Remove the views from the secondContainer
                view.removeFromSuperview()
            }
        }
    }
    
    // Function to completely reset the game
    func hardReset(){
        removeSlotImageViews()
        slots.removeAll(keepCapacity: true)
        self.setupSecondContainer(self.secondContainer)
        credits = 50
        winnings = 0
        currentBet = 0
        
        // Each time we do a hard rest we want to update our labels
        updateMainView()
    }
    
    // Function to update all the labels in the VC
    func updateMainView(){
        self.creditsLabel.text = "\(credits)"
        self.betLabel.text = "\(currentBet)"
        self.winnerPaidLabel.text = "\(winnings)"
    }
    
    func showAlertWithText(header: String = "Warning", message: String){
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}






















