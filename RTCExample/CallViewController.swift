//
//  CallViewController.swift
//  RTCExample
//
//  Created by young on 2022/09/21.
//

import UIKit

class CallViewController: UIViewController {
	private final let TAG = "CallController"
	var room: Room?
	var callId: String?

	@IBOutlet weak var tvTitle: UILabel!
	@IBOutlet weak var tvCount: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		Log(message: "\(TAG) \(#function)")

        // Do any additional setup after loading the view.
		navigationController?.setNavigationBarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
		if room != nil {
			Log(message: "\(TAG) room is \(room!)")
			tvTitle.text = room!.title
			var count = 0
			for call in room!.calls! {
				Log(message: "\(TAG) call is \(call)")
				if call.userId == AppDB.instance.getUserId() {
					callId = call.callId
					Log(message: "\(TAG) callId is \(callId!)")
				}
				if call.status.uppercased() != "TERMINATED" {
					count += 1
				}
			}
			tvCount.text = String(count)
		}
    }
	
	@IBAction func refresh(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		getRoomInfo(roomId: room!.roomId) {
			room in
			if room != nil {
				var count = 0
				for call in room!.calls! {
					Log(message: "\(self.TAG) call is \(call)")
					if (call.status.uppercased() != "TERMINATED") {
						count += 1
					}
				}
				DispatchQueue.main.async {
					self.tvCount.text = String(count)
				}
			}
		}
	}
	
	@IBAction func endCall(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		updateCallStatus(callId: callId!) {
			call in
			if call != nil {
				Log(message: "\(self.TAG) endCall call is \(call!)")
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
	
	@IBAction func sdp(_ sender: Any) {
		updateSDP(sdp: "sdsdp")
	}
	
	@IBAction func ice(_ sender: Any) {
		updateICE(ice: "iceice")
	}
	
	func updateSDP(sdp: String) {
		updateCallSDP(callId: callId!, sdp: sdp) {
			call in
			if call != nil {
				Log(message: "\(self.TAG) updateSDP call is \(call!)")
			}
		}
	}
	
	func updateICE(ice: String) {
		updateCallICE(callId: callId!, ice: ice) {
			call in
			if call != nil {
				Log(message: "\(self.TAG) updateICE call is \(call!)")
			}
		}
	}
}
