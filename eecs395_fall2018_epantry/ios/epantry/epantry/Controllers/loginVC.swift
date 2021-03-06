//
//  loginVC.swift
//  epantry
//
//  Created by Caleb Cain on 10/29/18.
//  Copyright © 2018 Caleb. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class LoginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func loginAttempt(_ sender: Any) {
        DispatchQueue.main.async {
            let user = self.username.text!
            var pw = self.password.text!
            
            pw = API.passwordHash(username: user, password: pw)
            
            var loggedIn: Bool = Bool()
            
            API.loginAttempt(username: user, password: pw, completionHandler: { (success, content, error) in
                loggedIn = success
                print(loggedIn)
                
                if (loggedIn) {
                    let vc: LaunchPageVC = self.storyboard?.instantiateViewController(withIdentifier: "LaunchPage") as! LaunchPageVC
                    self.present(vc, animated: true, completion: {
                        print("login successful")
                    })
                } else {
                    self.invalidLogin()
                }
            })
        }
    }
    
    func invalidLogin() {
        let dialogMessage = UIAlertController(title: "Invalid Login", message: "Login attempt failed.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButtonDidClick(_ sender: Any) {
        let vcRegister = self.storyboard?.instantiateViewController(withIdentifier: "RegisterPage") as! RegisterVC
        self.present(vcRegister, animated: true, completion: {
            print("Registration page presented")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.password.delegate = self
        assignbackground()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pantry.png")!)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func assignbackground(){
        let background = UIImage(named: "pantry.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.loginAttempt((Any).self)
        return true
    }
}
