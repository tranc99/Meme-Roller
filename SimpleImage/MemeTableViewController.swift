//
//  MemeTableViewController.swift
//  SimpleImage
//
//  Created by Tomahawk Africa Tindo on 8/26/15.
//  Copyright (c) 2015 Tomahawk Africa Tindo. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UIViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
            
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //load memes from the AppDelegate
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes

    }
}