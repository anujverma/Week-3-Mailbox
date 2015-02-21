//
//  MailboxViewController.swift
//  Week 3 Mailbox
//
//  Created by Anuj Verma on 2/19/15.
//  Copyright (c) 2015 Anuj Verma. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var mailboxFeedView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var laterIconImage: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var archiveIconImage: UIImageView!
    @IBOutlet weak var lowerFeedImage: UIImageView!
    @IBOutlet weak var leftMenu: UIImageView!
    @IBOutlet weak var mainViewContainer: UIView!
    @IBOutlet weak var secondFeedImage: UIImageView!
    
    var startingMessageImageCenter: CGPoint!
    var startingArchiveIconImageCenter: CGPoint!
    var originalMainViewCenterX: CGFloat!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mailboxScrollView.contentSize = mailboxFeedView.frame.size
        laterIconImage.alpha = 0.1
        archiveIconImage.alpha = 0.1
        rescheduleImageView.alpha = 0.0
        listImageView.alpha = 0.0
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mainViewContainer.addGestureRecognizer(edgeGesture)
        originalMainViewCenterX = mainViewContainer.center.x
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {
        
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began) {
            
            startingMessageImageCenter = messageImageView.center
            
        } else  if (sender.state == UIGestureRecognizerState.Changed) {
        
            println("Later icon x position \(laterIconImage.center.x)")
            println("Archive icon x position \(archiveIconImage.center.x)")

            
            messageImageView.center = CGPoint(x: startingMessageImageCenter.x + translation.x, y: messageImageView.center.y)
            
            if (translation.x < -60 && translation.x > -260) {
                archiveIconImage.alpha = 0.0
                messageContainerView.backgroundColor = UIColor(red: 247/255.0, green: 227/255.0, blue: 6/255.0, alpha: 1.0)
//                var laterImageXValue = convertValue(Float(translation.x), 0, -150, 300, 250)
                var laterImageXValue = messageImageView.center.x + 192
                println("X value of image: \(laterImageXValue)")
                laterIconImage.center.x = laterImageXValue
                laterIconImage.image = UIImage(named: "later_icon.png")

            } else if (0 > translation.x && translation.x > -60 ){
                archiveIconImage.alpha = 0.0
                var alphaValue = convertValue(Float(translation.x), 0, -70, 0.2, 1.0)
                println("Alpha value: \(alphaValue)")
                laterIconImage.alpha = CGFloat(alphaValue)
                messageContainerView.backgroundColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0)
            
            } else if (translation.x < -260) {
                
                println("Less than 260")
                archiveIconImage.alpha = 0.0
                laterIconImage.image = UIImage(named: "list_icon.png")
                var laterImageXValue = messageImageView.center.x + 198
                laterIconImage.center.x = laterImageXValue
                messageContainerView.backgroundColor = UIColor(red: 198/255.0, green: 156/255.0, blue: 109/255.0, alpha: 1.0)

            } else if (translation.x > 0 && translation.x < 60){
                laterIconImage.alpha = 0.0
                var alphaValue = convertValue(Float(translation.x), 0, 60, 0.2, 1.0)
                println("Alpha value2: \(alphaValue)")
                archiveIconImage.alpha = CGFloat(alphaValue)
                messageContainerView.backgroundColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 205/255.0, alpha: 1.0)
                
            } else if (translation.x > 60 && translation.x < 260){
                
                laterIconImage.alpha = 0.0
                messageContainerView.backgroundColor = UIColor(red: 57/255.0, green: 181/255.0, blue: 74/255.0, alpha: 1.0)
                var archiveImageXValue = messageImageView.center.x - 185
                println("X value of archive image: \(archiveImageXValue)")
                archiveIconImage.center.x = archiveImageXValue
                archiveIconImage.image = UIImage(named: "archive_icon.png")

            } else if (translation.x > 260) {
                laterIconImage.alpha = 0.0
                archiveIconImage.image = UIImage(named: "delete_icon.png")
                var laterImageXValue = messageImageView.center.x - 198
                laterIconImage.center.x = laterImageXValue
                messageContainerView.backgroundColor = UIColor(red: 237/255.0, green: 28/255.0, blue: 36/255.0, alpha: 1.0)
            }
            println(translation.x)

        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if (translation.x > -150 && translation.x < 0) {
                
                springBackMessage()
                
            } else if (translation.x > -260 && translation.x < -150.0){
                
                springBackMessage()

                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.listImageView.alpha = 1.0
                    }, completion: { (Bool) -> Void in
                        UIView.animateWithDuration(0.3, delay: 1.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                            self.listImageView.alpha = 0.0
                            }, completion: { (Bool) -> Void in
                                //
                        })
                })
                
                
            } else if (translation.x < -260) {
            
                springBackMessage()
                
                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.rescheduleImageView.alpha = 1.0
                }, completion: { (Bool) -> Void in
                    UIView.animateWithDuration(0.3, delay: 1.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                        self.rescheduleImageView.alpha = 0.0

                    }, completion: { (Bool) -> Void in
                        //
                    })
                })

            } else if (translation.x > 150) {
                springBackMessage()
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageContainerView.hidden = true
                    self.lowerFeedImage.center.y = 650
                }, completion: { (Bool) -> Void in

                })
                
            } else if (translation.x > 0 && translation.x < 150) {
                springBackMessage()
            }
        }
        
    }
    
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer){
//        println("Did edge pan main view")
//        println("Center x of main container: \(mainViewContainer.center.x)")
        var translation = sender.translationInView(view)
        if (sender.state == UIGestureRecognizerState.Began) {
            originalMainViewCenterX = mainViewContainer.center.x
        } else  if (sender.state == UIGestureRecognizerState.Changed) {
            println("Translation of edge pan x: \(translation.x)")
            println("Center x of main container: \(originalMainViewCenterX)")
            mainViewContainer.center.x = originalMainViewCenterX + translation.x
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            if (translation.x > 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    //
                    self.mainViewContainer.center.x = 445
                    }, completion: { (Bool) -> Void in
                        //
                })
            } else if (translation.x < 100) {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    //
                    self.mainViewContainer.center.x = 160.0
                    }, completion: { (Bool) -> Void in
                        //
                })
            }
        }
    }
    
    @IBAction func didPressHamburgerButton(sender: AnyObject) {
        println("Position of mainview x: \(mainViewContainer.center.x)")
        if (mainViewContainer.center.x == 160.0) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.mainViewContainer.center.x = 445
        })
            
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mainViewContainer.center.x = 160.0
            })
        }
    }
    

    func springBackMessage(){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 15, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.messageImageView.center.x = self.startingMessageImageCenter.x
            }, completion: { (Bool) -> Void in
                self.laterIconImage.center.x = 291.5
                self.archiveIconImage.center.x = 32.5
        })

    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            UIView.animateWithDuration(0.3, delay: 0.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.messageContainerView.hidden = false
                self.lowerFeedImage.center.y = 740
                }, completion: { (Bool) -> Void in
                    //
            })
        }
    }
    
    
    @IBAction func didPressSegmentedControl(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 1) {
            println("Center x of second image: \(secondFeedImage.center.x)")
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.secondFeedImage.center.x = 160
            })
        } else if (sender.selectedSegmentIndex == 0) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.secondFeedImage.center.x = 483
            })
        }
    }

    
}
