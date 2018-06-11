//
//  ViewController.swift
//  InstagramLogin
//
//  Created by Hitesh Surani on 11/06/18.
//  Copyright © 2018 Hitesh Surani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var instagramLogin: InstagramSharedVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginWithInstagram(_ sender:UIButton){
        
        if (UserDefaults.standard.value(forKey:"instUserID") != nil){
            getAllPhotosFromInstagram()
        }else{
            instagramLogin = InstagramSharedVC.init(clientId: Constants.clientId, redirectUri: Constants.redirectUri) { (token, error) in
                UserDefaults.standard.set(token ?? "", forKey: "instUserID") 
                
                self.instagramLogin.dismiss(animated: true, completion: {
                    self.getAllPhotosFromInstagram()
                })
            }
            present(UINavigationController(rootViewController: instagramLogin), animated: true)
        }
    }

    fileprivate func getAllPhotosFromInstagram() {

        InstagramUserProfile.shared.getInstagramPhotoWithUrl(comptionBlock: { (aryAllPhotos, status) in
            
            if status {
                print(aryAllPhotos)
            }else{
                print("failed to fetch post")
            }
        })
    }
}

