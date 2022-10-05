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
	var iceCandidates: String?

	@IBOutlet weak var tvTitle: UILabel!
	@IBOutlet weak var tvCount: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		Log(message: "\(TAG) \(#function)")

        // Do any additional setup after loading the view.
		navigationController?.setNavigationBarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
		let manager = RTPManager.instance
		var isOffer = true
		if room != nil {
			tvTitle.text = room!.title
//			processCalls(calls: room!.calls!)
			var count = 1
			for call in room!.calls! {
				if call.userId == AppDB.instance.getUserId() {
					self.callId = call.callId
					continue
				}
				if call.status.uppercased() == TERMINATED {
					continue
				}
				isOffer = false
				count += 1
				let remoteSDP = RTCSessionDescription(type: "offer", sdp: call.sdp!)!
				manager.createAnswer(delegate: self, remoteSDP: remoteSDP, candidates: call.ice!)
			}
		}
		
		if isOffer {
			manager.createOffer(delegate: self)
		}
		
//		RTPManager.instance.delegate = self
//		RTPManager.instance.createPeerConnectionFactory()
//		RTPManager.instance.createPeerConnection()
    }
	
	@IBAction func refresh(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		getRoomInfo(roomId: room!.roomId) { room in
			if room != nil {
				self.room = room
				self.processCalls(calls: room!.calls!)
			}
		}
	}
	
	@IBAction func endCall(_ sender: Any) {
		Log(message: "\(TAG) \(#function)")
		updateCallStatus(callId: callId!) {
			call in
			if call != nil {
				Log(message: "\(self.TAG) updateCallStatus success")
				DispatchQueue.main.async {
					self.navigationController?.popViewController(animated: true)
				}
				RTPManager.instance.end()
			}
		}
	}
	
	func processCalls(calls: Array<Call>) {
		var count = 1
		for call in calls {
//			Log(message: "\(self.TAG) call is \(call)")
			if call.userId == AppDB.instance.getUserId() {
				self.callId = call.callId
			} else {
				//Get Active Participants
				if call.status.uppercased() != TERMINATED {
					count += 1
//					let localSDP = addIceCandidates(sdp: call.sdp!, candidates: call.ice!)
					let sdp = RTCSessionDescription(type: "answer", sdp: call.sdp!)
					RTPManager.instance.setRemoteDescription(sdp: sdp!)
					let arr = call.ice!.components(separatedBy: ";")
					for iceSDP in arr {
						let ice = RTCICECandidate(mid: "audio", index: 0, sdp: iceSDP)
						RTPManager.instance.addRemoteICECandidate(ice: ice!)
					}
				}
			}
		}
		DispatchQueue.main.async {
			self.tvCount.text = String(count)
		}
	}
	
	func updateSDP(sdp: String) {
		updateCallSDP(callId: callId!, sdp: sdp) {
			success in
			if success {
				Log(message: "\(self.TAG) updateSDP success")
			}
		}
	}
	
	@objc func updateICECandidates() {
		updateCallICE(callId: callId!, ice: iceCandidates!, handler: {(success: Bool) -> Void in
			if success {
				Log(message: "\(self.TAG) updateICE success")
			}
		})
	}
	
	func updateICE() {
		DispatchQueue.main.async {
			NSObject.cancelPreviousPerformRequests(withTarget: self)
			self.perform(#selector(self.updateICECandidates), with: nil, afterDelay: 1)
		}
	}
}

extension CallViewController: WebRTCDelegate {
	func onSDPCreated(sdp: RTCSessionDescription) {
		updateSDP(sdp: sdp.description)
	}
	
	func onIceGenerated(ice: RTCICECandidate) {
		if self.iceCandidates == nil {
			self.iceCandidates = ice.sdp
		} else {
			self.iceCandidates! += ";" + ice.sdp
		}
		updateICE()
	}
}
