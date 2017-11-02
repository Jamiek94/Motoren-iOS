//
//  LoginViewController.swift
//  Motoren
//
//  Created by Jamie Knoef on 29/10/2017.
//  Copyright © 2017 Jamie Knoef. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email"]
        loginButton.delegate = self
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        
        loginWithCredentials(credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    private func loginWithCredentials(_ credentials : AuthCredential) {
        Auth.auth().signIn(with: credentials) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.performSegue(withIdentifier: "imagesOverview", sender: nil)
        }
    }
}
