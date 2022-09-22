//
//  SignViewController.swift
//  RTCExample
//
//  Created by young on 2022/09/13.
//

import UIKit

class SignViewController: UIViewController {
	final let TAG = "SignViewController"

	@IBOutlet weak var etId: UITextField!
	@IBOutlet weak var etPwd: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		Log(message: "\(TAG) \(#function)")
		
		navigationController?.setNavigationBarHidden(true, animated: true)
		
		etId.placeholder = "ID"
		etPwd.placeholder = "Password"
		etPwd.isSecureTextEntry = true
		etId.text = AppDB.instance.getUserId()
		etPwd.text = AppDB.instance.getPassword()
		
		getUser(
			userId: "user1"
		) { success, response in
			Log(message: "\(self.TAG) typeof users \(type(of: response))")
			Log(message: "\(self.TAG) users \(response)")
		}
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
    
	@IBAction func signIn(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		view.endEditing(true)
		
		if (!etId.text!.isEmpty && !etPwd.text!.isEmpty) {
			putSignIn(
				userId: etId.text!,
				password: etPwd.text!
			) {
				success, response in
				if success {
					Log(message: "\(self.TAG) signIn result \(response!)")
					DispatchQueue.main.async {
						AppDB.instance.setSignIn(signIn: true)
						AppDB.instance.setUserId(userId: response!.userId)
						AppDB.instance.setPassword(password: response!.password)
						self.navigationController?.popViewController(animated: true)
					}
				}
			}
		} else {
			Log(message: "et is empty")
		}
	}
	
	@IBAction func signUp(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		view.endEditing(true)
	}
}
