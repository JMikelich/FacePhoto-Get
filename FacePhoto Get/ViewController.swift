//
//  ViewController.swift
//  FacePhoto Get
//
//  Created by WorkBoy on 10/10/15.
//  Copyright (c) 2015 Lanzivision. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Accounts

 
let FBLoginStateNotification = "FBLoginStateNotification"


class ViewController: UIViewController {

    private var dict : NSDictionary!
    private var fbLoader : FBModule!
    private var fbLoggedIn : Bool!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Serup logged in observer
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onFBLoginStateNotification:",
            name: FBLoginStateNotification,
            object: nil)
        
        
        // Facebook log in vars/classes
        fbLoader = FBModule()
        fbLoggedIn = false
        
        
        
        }
    
    func onFBLoginStateNotification(notification: NSNotification) {
        if let newQuote = notification.object as? Bool {
            if(newQuote){
                // Facebook login successful. Adding necesarry UI elements and variable changes.
                fbLoggedIn = true
                
                let screenSize: CGRect = UIScreen.mainScreen().bounds
                let viewPhotosButton = UIButton()
                viewPhotosButton.setTitle("View imported photos", forState: UIControlState.Normal)
                viewPhotosButton.frame = CGRectMake(0, 0, screenSize.width , screenSize.height/6)
                viewPhotosButton.center = CGPointMake(screenSize.width/2, screenSize.height * 1/3)
                viewPhotosButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                viewPhotosButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
                viewPhotosButton.addTarget(self, action: "viewPhotosButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(viewPhotosButton)
                
                let importPhotosButton = UIButton()
                importPhotosButton.setTitle("Import photos", forState: UIControlState.Normal)
                importPhotosButton.frame = CGRectMake(0, 0, screenSize.width , screenSize.height/6)
                importPhotosButton.center = CGPointMake(screenSize.width/2, screenSize.height * 2/3)
                importPhotosButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                importPhotosButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
                self.view.addSubview(importPhotosButton)
             
            }
            else{
                fbLoggedIn = false
                // User has not successfully logged into facebook. Creating popup
                
                var alertController = UIAlertController(title: "You must login to Facebook for this app to work", message: "", preferredStyle: .Alert)
                
                // Create the actions
                var cancelAction = UIAlertAction(title: "Quit App", style: UIAlertActionStyle.Destructive) {
                    UIAlertAction in
                    
                    // User does not want to login, exit app
                    exit(0)
                }
                
                var okAction = UIAlertAction(title: "Retry Login", style: UIAlertActionStyle.Cancel) {
                    UIAlertAction in
                    
                    // Retry login
                    self.fbLoader.loginToFacebook()
                }
               
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                self.presentViewController(alertController, animated: true, completion: nil)
            }

        }
        
    }
    
    func viewPhotosButtonPressed(sender:UIButton){
        [self .performSegueWithIdentifier("importPhotos", sender: self)]
    }
    
    func importPhotosButtonPressed(sender:UIButton){
        [self .performSegueWithIdentifier("viewPhotos", sender: self)]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func getInfoButton(sender: AnyObject) {
    }
    
}

