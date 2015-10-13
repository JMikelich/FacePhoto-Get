//
//  FBModule.swift
//  FacePhoto Get
//
//  Purpose: This module handles all Facebook RESTful API calls. The reason for this is if it is necesarry to update
//  which API version used, all changes will be only in this class. This class is a Singleton, so it will only be
//  initialized once in the Intro View. 
//
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import Accounts



class FBModule {
   
    private var fbDataDictionary : NSDictionary!
    private var isLoggedIn : Bool!
    private var fbPermissions : NSString!
    private var fbParameters : NSString!
    
    
    init(){
        
        // Read metadata
        var dataDictionary : NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("MetadataPList", ofType: "plist"){
            dataDictionary = NSDictionary(contentsOfFile: path)
        }
        // If metadata is loaded in successfully
        if let dict = dataDictionary{
            
            fbPermissions = dict["FacebookPermissions"] as! String
            fbParameters = dict["FacebookParameters"] as! String

        }
        else{
            // Metadata not loaded, supply fbPermissions with empty string
            fbPermissions = ""
        }
        
        
        // Upon initialization the class attempts to log into facebook
        loginToFacebook()
        
        
    }
    
    // Determines if the user is already logged into facebook. 
    func loginToFacebook(){
        
        if (FBSDKAccessToken.currentAccessToken() != nil){
            
            // User is already logged into facebook
            self.getFBData()
            self.isLoggedIn = true
            
            // Send notification for the controller's listener
            let FBLoginStateCreateNotification = NSNotification(name: FBLoginStateNotification,
                object: self.isLoggedIn)
            NSNotificationCenter.defaultCenter().postNotification(FBLoginStateCreateNotification)
            
            
        }
        else{
            
            // Init login manager and login to facebook
            var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager .logInWithReadPermissions([fbPermissions], fromViewController: ViewController(), handler: { (result, error) -> Void in
                if (error == nil){
                    var fbloginresult : FBSDKLoginManagerLoginResult = result
                    
                    // Check if user is already logged in
                    if(fbloginresult.token != nil){
                        if(fbloginresult.grantedPermissions.contains(self.fbPermissions))
                        {
                            // User logged in and granted permissions
                            self.getFBData()
                            self.isLoggedIn = true
                            
                            // Send notification for the controller's listener
                            let FBLoginStateCreateNotification = NSNotification(name: FBLoginStateNotification,
                                object: self.isLoggedIn)
                            NSNotificationCenter.defaultCenter().postNotification(FBLoginStateCreateNotification)
                            
                        }
                    }
                    else{
                        
                        // Login unsuccessful, the user needs to try again
                        self.isLoggedIn = false
                        let FBLoginStateCreateNotification = NSNotification(name: FBLoginStateNotification,
                            object: self.isLoggedIn)
                        NSNotificationCenter.defaultCenter().postNotification(FBLoginStateCreateNotification)
                        
                       
                        
                    }
                }
            })
        }
    }
    
    func getFBData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": fbParameters]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.fbDataDictionary = result as! NSDictionary
                    println(result)
                    println(self.fbDataDictionary)
                    NSLog(self.fbDataDictionary.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }

    }
    

}