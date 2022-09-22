//
//  Call.swift
//  RTCExample
//
//  Created by young on 2022/09/19.
//

import Foundation

private let TAG = "Call"

struct Call: Codable {
	let id: Int?
	let callId: String
	let userId: String
	let roomId: String
	let status: String
	let sdp: String?
	let ice: String?
	let createdDate: String
	let modifiedDate: String
}

func updateCallStatus(
	callId: String,
	handler: @escaping (Call?) -> Void
) {
	request(
		url: UPDATE_CALL_STATUS,
		method: PUT,
		param: ["callId":callId, "status":"terminated"]
	) {
		success, response in
		guard success else {
			handler(nil)
			return
		}
		
		guard let call = parseCall(response: response!) else {
			handler(nil)
			return
		}
		
		handler(call)
	}
}

func updateCallSDP(
	callId: String,
	sdp: String,
	handler: @escaping (Call?) -> Void
) {
	request(
		url: UPDATE_CALL_SDP,
		method: PUT,
		param: ["callId":callId, "sdp":sdp]
	) {
		success, response in
		guard success else {
			handler(nil)
			return
		}
		
		guard let call = parseCall(response: response!) else {
			handler(nil)
			return
		}
		
		handler(call)
	}
}

func updateCallICE(
	callId: String,
	ice: String,
	handler: @escaping (Call?) -> Void
) {
	request(
		url: UPDATE_CALL_ICE,
		method: PUT,
		param: ["callId":callId, "ice":ice]
	) {
		success, response in
		guard success else {
			handler(nil)
			return
		}
		
		guard let call = parseCall(response: response!) else {
			handler(nil)
			return
		}
		
		handler(call)
	}
}

func parseCall(response: Any) -> Call? {
	guard let body = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) else {
		Log(message: "\(TAG) serialization error")
		return nil
	}
	
	return try? JSONDecoder().decode(Call.self, from: body)
}
