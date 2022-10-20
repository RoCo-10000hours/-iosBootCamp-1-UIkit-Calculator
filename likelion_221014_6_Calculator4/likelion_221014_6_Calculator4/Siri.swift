//
//  Siri.swift
//  likelion_221014_6_Calculator4
//
//  Created by 원태영 on 2022/10/14.
//

import Foundation
import AVFoundation

struct Siri {
    static let mySynthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    private init() {}
    
    static func speakText(_ x: Double, _ y: Double, _ text : String, _ result : String) {
        
        var x = String(x)
        var y = String(y)
        
        if x.hasSuffix(".0") {
            x.removeLast(2)
        }
        if y.hasSuffix(".0") {
            y.removeLast(2)
        }
        
        let gwa : [String] = ["1","3","6","7","8"]
        
        let t = gwa.contains(String(x.last!)) ? "과" : "와"
        
        let voiceText : String = "\(x)\(t) \(y)의 \(text) 계산 결과는 \(result)입니다."

        let utterance : AVSpeechUtterance = AVSpeechUtterance(string: voiceText)

        mySynthesizer.speak(utterance)
    }
    
    /// siri 말하기 멈추기
    static func stopText() {
        mySynthesizer.stopSpeaking(at: .immediate)
    }
}
