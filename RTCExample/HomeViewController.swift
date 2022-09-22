//
//  HomeViewController.swift
//  RTCExample
//
//  Created by young on 2022/09/13.
//

import UIKit

class HomeViewController: UIViewController {
	private final let TAG = "HomeController"

	@IBOutlet weak var etRoomTitle: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		Log(message: "\(TAG) \(#function)")
		
		if !AppDB.instance.isSignIn() {
			goToSign()
		}
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	@IBAction func call(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		view.endEditing(true)
		if (etRoomTitle.text != nil && !etRoomTitle.text!.isEmpty) {

			enterRoom(userId: AppDB.instance.getUserId(), title: etRoomTitle.text!) {
				room in
				if (room != nil) {
					Log(message: "\(self.TAG) room is \(room!)")
					DispatchQueue.main.async {
						self.goToCall(room: room!)
					}
				}
			}
			etRoomTitle.text = ""
		}
	}
	
	@IBAction func message(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		view.endEditing(true)
	}
	
	@IBAction func signOut(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		AppDB.instance.setSignIn(signIn: false)
		goToSign()
	}
	
	private func goToSign() {
		let board = UIStoryboard(name: STORY_BOARD, bundle: nil)
		let signController = board.instantiateViewController(withIdentifier: SIGN_VIEW) as! SignViewController
		navigationController?.pushViewController(signController, animated: false)
	}
	
	private func goToCall(room: Room) {
		let board = UIStoryboard(name: STORY_BOARD, bundle: nil)
		let callController = board.instantiateViewController(withIdentifier: "call") as! CallViewController
		callController.room = room
		navigationController?.pushViewController(callController, animated: false)
	}
}
