//
//  Request.swift
//  RTCExample
//
//  Created by young on 2022/09/19.
//

import Foundation

private let TAG = "Request"

struct Header: Codable {
	let status: Int
	let code: Int
	let description: String
}

struct Body: Codable {}

struct Response: Codable {
	let header: Header
	let body: String
}

func request(url: String, method: String, param: [String: Any]?, handler: @escaping (Bool, Any?) throws -> Void) {
	//Check URL format
	guard let url = URL(string: url) else {
		Log(message: "Error: cannot create URL")
		try? handler(false, nil)
		return
	}
	
	var request = URLRequest(url: url)
	request.httpMethod = method
	if (param != nil) {
		let sendData = try! JSONSerialization.data(withJSONObject: param!, options: [])
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = sendData
	}
	
	URLSession.shared.dataTask(with: request) { data, response, error in
		//Request Error
		if error != nil {
			Log(message: "Error: error calling \(method)")
			Log(error: error!)
			try? handler(false, nil)
			return
		}
		//No Data Error
		guard let data = data else {
			Log(message: "Error: Did not receive data")
			return
		}
		//Successful response 200~299
		guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
			Log(message: "Error: HTTP request failed")
			try? handler(false, nil)
			return
		}
		
		let dic = try? toDictionary(data: data)
		guard dic != nil else {
			Log(message: "Error: Failed parsing dictionary")
			try? handler(false, nil)
			return
		}
		let body = dic![BODY]
		guard body != nil else {
			Log(message: "Error: Failed parsing BODY")
			try? handler(false, nil)
			return
		}
		
		if checkHeader(dictionary: dic!) {
			Log(message: "Request \(url) Success")
			try? handler(true, body)
			return
		}
		Log(message: "Request fail")
		try? handler(false, nil)
	}.resume()
}

func toDictionary(data: Data) throws -> [String: Any]? {
	return try JSONSerialization.jsonObject(with: data) as? [String: Any]
}

func checkHeader(dictionary: Dictionary<String, Any>) -> Bool {
	let header = dictionary[HEADER] as? Dictionary<String, Any>
	if (header != nil) {
		let status = header![STATUS] as? Int
		if status != 1 {
			Log(message: "\(TAG) header is \(header!)")
		}
		return status == 1
	}
	return false
}
