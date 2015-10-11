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



class ViewController: UIViewController {

     var dict : NSDictionary!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], fromViewController: self, handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    //fbLoginManager.logOut()
                }
            }
        })

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! NSDictionary
                    println(result)
                    println(self.dict)
                    NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                }
            })
        }
    }
    
    @IBAction func getInfoButton(sender: AnyObject) {
    }
    
}

