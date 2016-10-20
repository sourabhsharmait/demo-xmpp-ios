


//
//  ViewController.swift
//  testSWIFTXMPPF
//
//  Created by Paul on 29/07/2015.
//  Copyright © 2015 ProcessOne. All rights reserved.
//

import UIKit
import XMPPFramework

class RosterTableViewController: UITableViewController, ChatDelegate {

	var onlineBuddies = NSMutableArray()
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		appDelegate.delegate = self
	}

	override func viewDidAppear(_ animated: Bool) {
		if (UserDefaults.standard.object(forKey: "userID") != nil) {
			if appDelegate.connect() {
				self.title = appDelegate.xmppStream?.myJID.bare()
				appDelegate.xmppRoster.fetch()
			}
		} else {
			performSegue(withIdentifier: "Home.To.Login", sender: self)
		}
	}
	
	//MARK: TableView Delegates
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath as IndexPath)
		
		cell.textLabel?.text = onlineBuddies[indexPath.row] as? String
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return onlineBuddies.count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let alertController = UIAlertController(title: "Warning!", message: "It will send Yo! to the recipient, continue ?", preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
			alertController.dismiss(animated: true, completion: nil)
		}))
		
		alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) -> Void in
			let message = "Yo!"
			let senderJID = XMPPJID.init(string: self.onlineBuddies[indexPath.row] as? String)
			let msg = XMPPMessage(type: "chat", to: senderJID)
			
			msg?.addBody(message)
			self.appDelegate.xmppStream?.send(msg)
		}))
		present(alertController, animated: true, completion: nil)
	}
	
	//MARK: Chat delegates
	func buddyWentOnline(_ name: String) {
		if !onlineBuddies.contains(name) {
			onlineBuddies.add(name)
			tableView.reloadData()
		}
	}
	
	func buddyWentOffline(_ name: String) {
		onlineBuddies.remove(name)
		tableView.reloadData()
	}
	
	func didDisconnect() {
		onlineBuddies.removeAllObjects()
		tableView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

