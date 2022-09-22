//
//  User.swift
//  RTCExample
//
//  Created by young on 2022/09/19.
//

import Foundation

struct User: Codable {
	let id: Int
	let userId: String
	let email: String
	let name: String
	let password: String
	let createdDate: String
	let modifiedDate: String
}

func getUsers(
	handler: @escaping (Bool, Any) -> Void
) {
	request(
		url: GET_USERS,
		method: GET,
		param: nil
	) {
		(success, response) in
		guard success else {
			Log(message: "User getUsers() failed")
			return
		}
		
		guard let users = parsingUser(source: response!) as? Array<User> else {
			Log(message: "User getUsers response is nil")
			return
		}
		handler(true, users)
	}
}

func getUser(
	userId: String,
	handler: @escaping (Bool, Any) -> Void
) {
	request(
		url: "\(GET_USER)\(userId)",
		method: GET, param: nil
	) {
		success, response in
		guard success else {
			Log(message: "User getUser(userId=\(userId) failed")
			return
		}
		
		guard let user = parsingUser(source: response!) as? User else {
			Log(message: "User getUser response is nil")
			return
		}
		handler(true, user)
	}
}

func putSignIn(
	userId: String,
	password: String,
	handler: @escaping (Bool, User?) -> Void
) {
	request(
		url: SIGN_IN,
		method: PUT,
		param: [
			"userId": userId,
			"password": password
		]
	) {
		success, response in
		guard success else {
			Log(message: "User putSignIn(userId=\(userId) failed")
			return
		}
		
		guard let user = parsingUser(source: response!) as? User else {
			Log(message: "User putSignIn response is nil")
			return
		}
		handler(true, user)
	}
}

func parsingUser(source: Any) -> Any? {
	if (source is NSArray) {
		var users = Array<User>()
		for response in source as! NSArray {
			guard let body = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted) else {
				return nil
			}
			let user = try! JSONDecoder().decode(User.self, from: body)
			users.append(user)
		}
		return users
	} else if (source is NSDictionary) {
		guard let data = try? JSONSerialization.data(withJSONObject: source, options: .prettyPrinted) else {
			return nil
		}
		guard let user = try? JSONDecoder().decode(User.self, from: data) else {
			return nil
		}
		return user
	}
	return nil
}
