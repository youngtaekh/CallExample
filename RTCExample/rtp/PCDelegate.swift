//
//  PCDelegate.swift
//  RTCExample
//
//  Created by young on 2022/09/23.
//

import Foundation

class PCDelegate: NSObject, RTCPeerConnectionDelegate {
	private let TAG = "PCDelegate"
	
	func peerConnection(_ peerConnection: RTCPeerConnection, signalingStateChanged stateChanged: RTCSignalingState) {
		Log(message: "\(TAG) peerConnection signalingStateChanged \(String(describing: stateChanged))")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, addedStream stream: RTCMediaStream) {
		Log(message: "\(TAG) peerConnection didAdd")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, removedStream stream: RTCMediaStream) {
		Log(message: "\(TAG) peerConnection didRemove")
	}
	
	func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
		Log(message: "\(TAG) peerConnectionShouldNegotiate")
	}
	
	func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) {
		Log(message: "\(TAG) peerConnection onRenegotiationNeeded")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, iceConnectionChanged newState: RTCICEConnectionState) {
		Log(message: "\(TAG) peerConnection iceConnectionState changed \(String(describing: newState.rawValue))")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, iceGatheringChanged newState: RTCICEGatheringState) {
		Log(message: "\(TAG) peerConnection iceGatheringState changed \(String(describing: newState))")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, gotICECandidate candidate: RTCICECandidate) {
//		Log(message: "\(TAG) peerConnection iceConnection generated")
		RTPManager.instance.delegate?.onIceGenerated(ice: candidate)
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCICECandidate]) {
		Log(message: "\(TAG) peerConnection iceConnection removed")
	}
	
	func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
		Log(message: "\(TAG) peerConnection dataChannel open")
	}
}
