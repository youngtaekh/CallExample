//
//  Room.swift
//  RTCExample
//
//  Created by young on 2022/09/19.
//

import Foundation

private let TAG = "Room"

struct Room: Codable {
	let roomId: String
	let ownerId: String
	let title: String
	let description: String
	let status: String
	let password: String
	let calls: Array<Call>?
}

func enterRoom(
	userId: String,
	title: String,
	description: String? = nil,
	password: String? = nil,
	handler: @escaping (Room?) -> Void
) {
	var param = ["ownerId":userId, "title":title]
	if (description != nil) {
		param["description"] = description
	}
	if password != nil {
		param["password"] = password
	}
	Log(message: "\(TAG) param is \(param)")
	
	request(
		url: ENTER_ROOM,
		method: POST,
		param: param
	) {
		success, response in
		guard success else {
			handler(nil)
			return
		}
		
		let room = parseRoom(response: response!)
		
		handler(room)
	}
}

func getRoomInfo(
	roomId: String,
	handler: @escaping (Room?) -> Void
) {
	request(
		url: "\(GET_ROOM)\(roomId)",
		method: GET,
		param: nil
	) {
		success, response in
		guard success else {
			Log(message: "\(TAG) request failed")
			handler(nil)
			return
		}
		
		let room = parseRoom(response: response!)
		
		handler(room)
	}
}

func parseRoom(response: Any) -> Room? {
	guard let body = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) else {
		Log(message: "\(TAG) serialization error")
		return nil
	}
	
	return try? JSONDecoder().decode(Room.self, from: body)
}
