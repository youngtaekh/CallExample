//
//  SDPEditor.swift
//  RTCExample
//
//  Created by young on 2022/10/04.
//

import Foundation

func addIceCandidates(sdp: String, candidates: String) -> String {
	
	var find = false
	let lines = sdp.split(whereSeparator: \.isNewline)
	var rValue = ""
	
	Log(message: "lines count \(lines.count)")
	var i = 0
	for line in lines {
		i += 1
		Log(message: "line is \(i) \(line)")
		if (line.starts(with: "a=ice")) {
			Log(message: "start with a=ice")
			find = true
			rValue.append(contentsOf: line)
			rValue.append(contentsOf: "\n\r")
			continue
		}
		if (find && !line.starts(with: "a=ice")) {
			Log(message: "Doesn't start with a=ice")
			find = false
			let candidateArray = candidates.components(separatedBy: ";")
			for candidate in candidateArray {
				Log(message: "candidate is \(candidate)")
				rValue.append(contentsOf: "a=")
				rValue.append(contentsOf: candidate)
				rValue.append(contentsOf: "\n\r")
			}
		}
		rValue.append(contentsOf: line)
		if (i != lines.count) {
			rValue.append(contentsOf: "\n\r")
		} else {
			Log(message: "Last line")
		}
	}
	
	return rValue
}
