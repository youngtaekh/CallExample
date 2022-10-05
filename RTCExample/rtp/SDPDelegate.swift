//
//  SDPDelegate.swift
//  RTCExample
//
//  Created by young on 2022/09/23.
//

import Foundation

class SDPDelegate: NSObject, RTCSessionDescriptionDelegate {
	private let TAG = "SDPDelegate"
	
	var pc: RTCPeerConnection?

	func peerConnection(_ peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: Error!) {
		if error == nil {
			Log(message: "\(TAG) didCreateSessionDescription")
			let manager = RTPManager.instance
			manager.pc?.setLocalDescriptionWith(self, sessionDescription: sdp)
			manager.delegate?.onSDPCreated(sdp: sdp)
		} else {
			Log(message: "\(TAG) didCreateSessionDescription error \(error!)")
		}
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: Error!) {
		Log(message: "\(TAG) didSetSessionDescriptionWithError")
		if error != nil {
			print(error!)
		}
	}
}
