//
//  RTPManager.swift
//  RTCExample
//
//  Created by young on 2022/09/22.
//

import Foundation
import AVFoundation
//import WebRTC

protocol WebRTCDelegate: AnyObject {
	func onSDPCreated(sdp: RTCSessionDescription)
	func onIceGenerated(ice: RTCICECandidate)
}

class RTPManager: NSObject {
	//isAudio, isVideo, isDataChannel
	//create PeerConnectionFactory
	//create PeerConnection
	//createOffer
	//createAnswer
	//constraints - offerToReceiveAudio/Video
	//SDP Event
	//PeerConnection Event
	private let TAG = "RTPManager"
	
	static let instance = RTPManager()
	
	var factory: RTCPeerConnectionFactory?
	var pc: RTCPeerConnection?
	var pcDelegate: PCDelegate?
	var sdpDelegate: SDPDelegate?
	
	var delegate: WebRTCDelegate?
	
	var defaultAudioTrack: RTCAudioTrack?
	var defaultVideoTrack: RTCVideoTrack?
	
	var isVideo = false
	var isFrontCamera = true
	
	func createPeerConnectionFactory() {
		RTCPeerConnectionFactory.initializeSSL()
		factory = RTCPeerConnectionFactory()
	}
	
	func createPeerConnection() {
		//constraints - dtls srtp key agreement
		let optionConstraints = [RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]
		let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: optionConstraints as [Any])
		//ice server
		let stunServer = URL(string: STUN_SERVER)
		var iceServer = Array(arrayLiteral: RTCICEServer(uri: stunServer, username: "", password: ""))
		
		pcDelegate = PCDelegate()
		pc = factory?.peerConnection(withICEServers: iceServer as [Any], constraints: constraints, delegate: pcDelegate!)
		pc?.add(createLocalMediaStream())
	}
	
	func createOffer(delegate: WebRTCDelegate) {
		self.delegate = delegate
		createPeerConnectionFactory()
		createPeerConnection()
		sdpDelegate = SDPDelegate()
		sdpDelegate?.pc = pc
		let constraints = [
			RTCPair.init(key: "OfferToReceiveAudio", value: "true"),
			RTCPair.init(key: "OfferToReceiveVideo", value: "false")
		]
		pc?.createOffer(
			with: sdpDelegate,
			constraints: RTCMediaConstraints(
				mandatoryConstraints: constraints as [Any],
				optionalConstraints: nil)
		)
	}
	
	func createAnswer(delegate: WebRTCDelegate, remoteSDP: RTCSessionDescription, candidates: String) {
		self.delegate = delegate
		createPeerConnectionFactory()
		createPeerConnection()
		sdpDelegate = SDPDelegate()
		sdpDelegate?.pc = pc
		
		setRemoteDescription(sdp: remoteSDP)
		let candidateArray = candidates.components(separatedBy: ";")
		for candidate in candidateArray {
			addRemoteICECandidate(ice: RTCICECandidate(mid: "audio", index: 0, sdp: candidate))
		}
		
		let constraints = [
			RTCPair.init(key: "OfferToReceiveAudio", value: "true"),
			RTCPair.init(key: "OfferToReceiveVideo", value: "false")
		]
		pc?.createAnswer(with: sdpDelegate, constraints: RTCMediaConstraints(mandatoryConstraints: constraints as [Any], optionalConstraints: nil))
	}
	
	func setLocalDescription(sdp: RTCSessionDescription) {
		pc?.setLocalDescriptionWith(sdpDelegate, sessionDescription: sdp)
	}
	
	func setRemoteDescription(sdp: RTCSessionDescription) {
		pc?.setRemoteDescriptionWith(sdpDelegate, sessionDescription: sdp)
	}
	
	func addRemoteICECandidate(ice: RTCICECandidate) {
		pc?.add(ice)
	}
	
	func end() {
		pc?.close()
		pcDelegate = nil
		sdpDelegate = nil
		delegate = nil
		pc = nil
		factory = nil
	}
	
	func createLocalMediaStream() -> RTCMediaStream {
		let localStream = factory?.mediaStream(withLabel: "ARDAMS")
		
		if isVideo {
			let localVideoTrack = createLocalVideoTrack()
			localStream?.addVideoTrack(localVideoTrack)
			//TODO: Add Delegate
		}
		
		localStream?.addAudioTrack(factory!.audioTrack(withID: "ARDAMSa0"))
		return localStream!
	}
	
	func createLocalVideoTrack() -> RTCVideoTrack? {
		var localVideoTrack: RTCVideoTrack?
		
		var cameraId: String? = nil
		var position: AVCaptureDevice.Position = .front
		if !isFrontCamera {
			position = .back
		}
		let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: position)
		for device in discoverySession.devices {
			cameraId = device.localizedName
			break
		}
		if cameraId == nil {
			return nil
		}
		
		let capturer = RTCVideoCapturer.init(deviceName: cameraId)
		let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
		let videoSource = factory?.videoSource(with: capturer, constraints: constraints)
		localVideoTrack = factory?.videoTrack(withID: "ARDAMSv0", source: videoSource)
		
		return localVideoTrack
	}
	
	func muteAudio() {
		let localStream = pc?.localStreams[0] as! RTCMediaStream
		defaultAudioTrack = localStream.audioTracks[0] as? RTCAudioTrack
		localStream.removeAudioTrack((localStream.audioTracks[0] as! RTCAudioTrack))
		pc?.remove(localStream)
		pc?.add(localStream)
	}
	
	func unmuteAudio() {
		let localStream = pc?.localStreams[0] as! RTCMediaStream
		localStream.addAudioTrack(defaultAudioTrack)
		pc?.remove(localStream)
		pc?.add(localStream)
	}
	
	func muteVideo() {
		let localStream = pc?.localStreams[0] as! RTCMediaStream
		defaultVideoTrack = localStream.videoTracks[0] as? RTCVideoTrack
		localStream.removeVideoTrack(localStream.videoTracks[0] as? RTCVideoTrack)
		pc?.remove(localStream)
		pc?.add(localStream)
	}
	
	func unmuteVideo() {
		let localStream = pc?.localStreams[0] as! RTCMediaStream
		localStream.addVideoTrack(defaultVideoTrack)
		pc?.remove(localStream)
		pc?.add(localStream)
	}
	
	func changeCamera() {
		let localStream = pc?.localStreams[0] as! RTCMediaStream
		localStream.removeVideoTrack(localStream.videoTracks[0] as? RTCVideoTrack)
		
		isFrontCamera = !isFrontCamera
		let localVideoTrack = createLocalVideoTrack()
		
		if localVideoTrack != nil {
			localStream.addVideoTrack(localVideoTrack)
		}
		pc?.remove(localStream)
		pc?.add(localStream)
	}
}
