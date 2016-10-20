//
//  LoginViewController.swift
//  testSWIFTXMPPF
//
//  Created by Paul on 30/07/2015.
//  Copyright © 2015 ProcessOne. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet var loginTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		loginTextField.text = "XMPPaccount@domainname"
		passwordTextField.text = "XMPPpassword"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func login(_ sender: AnyObject) {
		UserDefaults.standard.set(loginTextField.text!, forKey: "userID")
		UserDefaults.standard.set(passwordTextField.text!, forKey: "userPassword")
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		if appDelegate.connect() {
			dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func done(_ sender: AnyObject) {
		dismiss(animated: true, completion: nil)
	}
}
