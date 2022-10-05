//
//  Config.swift
//  RTCExample
//
//  Created by young on 2022/09/14.
//

import Foundation

//constant
let STORY_BOARD = "Main"
let SIGN_VIEW = "sign"

let TERMINATED = "TERMINATED"

let HEADER = "header"
let CODE = "code"
let STATUS = "status"
let DESC = "description"
let BODY = "body"

let GET = "GET"
let POST = "POST"
let PUT = "PUT"
let DELETE = "DELETE"

//api
let API_URL = "http://192.168.0.30:3465/"
let GET_USERS = "\(API_URL)user"
let GET_USER = "\(API_URL)user?userId="
let SIGN_IN = "\(API_URL)user/sign"

let ENTER_ROOM = "\(API_URL)room"
let GET_ROOM = "\(API_URL)room?roomId="

let UPDATE_CALL_STATUS = "\(API_URL)call/status"
let UPDATE_CALL_SDP = "\(API_URL)call/sdp"
let UPDATE_CALL_ICE = "\(API_URL)call/ice"

let STUN_SERVER = "stun:stun.l.google.com:19302"
