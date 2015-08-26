//
//  ViewController.swift
//  SimpleImage
//
//  Created by Tomahawk Africa Tindo on 8/24/15.
//  Copyright (c) 2015 Tomahawk Africa Tindo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    var anchorPoint = CGFloat(0)
    
    @IBAction func pickAnImage(sender: AnyObject) {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func snapImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topText.delegate = self
        bottomText.delegate = self
        anchorPoint = self.view.frame.origin.y
        
        //topText.defaultTextAttributes = memeTextAttributes
        //bottomText.defaultTextAttributes = memeTextAttributes
    }

    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.frame.origin.y = self.view.center.y
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickerView.image = image
            self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField.text == "BOTTOM") {
            println("we in the top nigga")
            self.subscribeToKeyboardNotifications()
        }
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.frame.origin.y = anchorPoint
        //self.view.center.y
        textField.resignFirstResponder()
        return true
    }
    
    //save memes
    @IBAction func save() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.setToolbarItems([], animated: true)
        var memedImage = generateMemedImage()
        var meme = Meme()
        meme.topText = self.topText.text
        meme.bottomText = self.bottomText.text
        meme.memedImage = memedImage
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println("SAVED a meme")
        var myView = UIImageView(image: meme.memedImage)
        let vc = UIViewController()
        vc.view.addSubview(myView)
        //self.presentViewController(vc, animated: true, completion: nil)
        //return meme.memedImage
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        var memedImage = generateMemedImage()
        var activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionHandler = {(activityType, completed: Bool) in
            self.save()
            if !completed {
                println("cancelled")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    //generate the combined image
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

}

