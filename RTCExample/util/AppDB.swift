//
//  AppDB.swift
//  RTCExample
//
//  Created by young on 2022/09/14.
//

import Foundation

class AppDB: NSObject {
	private let TAG = "AppDB"
	private let SIGN_IN = "signIn"
	private let USER_ID = "userId"
	private let PASSWORD = "password"
	
	static let instance = AppDB()
	var preference: UserDefaults
	
	override init() {
		preference = UserDefaults.standard
	}
	
	func putString(key: String, value: String) {
		preference.set(value, forKey: key)
		preference.synchronize()
	}
	
	func getString(key: String) -> String {
		if (preference.string(forKey: key) == nil) {
			return ""
		}
		return preference.string(forKey: key)!
	}
	
	func putBool(key: String, value: Bool) {
		preference.set(value, forKey: key)
		preference.synchronize()
	}
	
	func getBool(key: String) -> Bool {
		return preference.bool(forKey: key)
	}
	
	func putInt(key: String, value: Int) {
		preference.set(value, forKey: key)
		preference.synchronize()
	}
	
	func getInt(key: String) -> Int {
		return Int(preference.integer(forKey: key))
	}
	
	func setSignIn(signIn: Bool) {
		putBool(key: SIGN_IN, value: signIn)
	}
	
	func isSignIn() -> Bool {
		return getBool(key: SIGN_IN)
	}
	
	func setUserId(userId: String) {
		putString(key: USER_ID, value: userId)
	}
	
	func getUserId() -> String {
		getString(key: USER_ID)
	}
	
	func setPassword(password: String) {
		putString(key: PASSWORD, value: password)
	}
	
	func getPassword() -> String {
		getString(key: PASSWORD)
	}
}
