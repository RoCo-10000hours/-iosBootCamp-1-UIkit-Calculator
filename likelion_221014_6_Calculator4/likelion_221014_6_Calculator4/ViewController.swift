//
//  ViewController.swift
//  likelion_221014_6_Calculator4
//
//  Created by 원태영 on 2022/10/14.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    /// variables
    var result : String = ""
    let operatorCharacterSet : CharacterSet = ["+","-","x","÷"]
    let operatorList : [String] = ["+","-","x","÷"]
    
    /// IBOutlets
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    /// 모든 버튼 속성: outlet collection
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cornerRadiusSetting()
    }
    
    /// IBActions
    @IBAction func numpadButtonTapped(_ sender : UIButton) {
        
        // 버튼 입력시 눌림효과 애니메이션
        buttonAnimation(sender)
        
        // 버튼의 title값 받아오기
        guard let buttonValue = sender.currentTitle else {
            return
        }
        
        // 결과 버튼이면 계산하기 함수 동작
        guard buttonValue != "=" else {
            
            // 연산자 입력이 없이 계산 버튼을 눌렀으면 계산 동작 실행 X
            guard Int(numberLabel.text!) == nil else {
                return
            }
            
            let lastValue : String = String(numberLabel.text!.last!)
            
            // 마지막이 연산자로 끝나면, 마지막 숫자로 0을 추가하고 계산 실행
            if operatorList.contains(lastValue) {
                numberLabel.text! += "0"
            }
            calculate()
            return
        }
        
        // 백스페이스 버튼이면 끝에 숫자 or 문자 한개 지우기
        guard buttonValue != "⌫" else {
            numberLabel.text!.removeLast()
            return
        }
        
        // All Clear 버튼이면 입력 내용 다 지우기
        guard buttonValue != "AC" else {
            numberLabel.text! = ""
            resultLabel.text! = ""
            result = ""
            // siri 말하기 즉시 멈추기
            Siri.stopText()
            return
        }
        
        // 첫 계산이어서 아직 결과가 없을 때
        if result.isEmpty {
            numberLabel.text! += buttonValue
        }
        
        // 계산 결과가 있음 && 받은 버튼이 연산자임
        else if !Character(buttonValue).isNumber{
            numberLabel.text! = result + buttonValue
            result = ""
            resultLabel.text! = ""
        }
        
        // 계산 결과가 있음 && 받은 버튼이 숫자임
        else {
            result = ""
            resultLabel.text! = ""
            numberLabel.text! = ""
            numberLabel.text! += buttonValue
        }
    }
}


extension ViewController {
    
    func calculate() {
        // 연산자 식별해서 할당하기
        let inputOperator = numberLabel.text!.filter{$0.isNumber == false && $0 != "."}
        
        // 연산자 기준으로 분리한 숫자 배열
        let numList = numberLabel.text!.components(separatedBy: operatorCharacterSet)

        // 연산자 기준으로 나눈 숫자 1
        let x = Double(numList[0])!
        // 연산자 기준으로 나눈 숫자 2
        let y = Double(numList[1])!
        
        // 음성 인식용 텍스트
        var categoryText : String = ""

        // 연산자 케이스에 따라 계산하기
        switch inputOperator {
        case "+":
            result = String((round((x + y)*100)/100))
            categoryText = "더하기"
        case "-":
            result = String((round((x - y)*100)/100))
            categoryText = "빼기"
        case "x":
            result = String((round((x * y)*100)/100))
            categoryText = "곱하기"
        case "÷":
            result = String((round((x / y)*100)/100))
            categoryText = "나누기"
        default:
            print("error")
        }

        // 결과가 정수면 .0 자르고 정수 부분만 남기기
        if result.hasSuffix(".0") {
            result.removeLast(2)
        }
        
        // 결과 라벨 업데이트
        resultLabel.text = "\(result)"
        
        // 읽어주기
        Siri.speakText(x, y, categoryText, result)
    }
    
    /**
    모든 화면 컴포넌트 **cornerRadius** 적용하기
     
     [corner Radius]:
     https://dongkyprogramming.tistory.com/15 "참고링크"
     
     자세한 내용은 제시된 주소 참고 [corner Radius].
     */
    
    private func cornerRadiusSetting() {
        [numberLabel, resultLabel].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 20.0
        }
        buttons.forEach{
            $0.layer.cornerRadius = 35.0
        }
    }
    
    /**
      버튼 애니메이션  *참고 링크*
     
      [button animaion]: https://stackoverflow.com/questions/31320819/scale-uibutton-animation-swift/ "참고링크"
     
      자세한 내용은 제시된 주소 참고 [button animaion].
    */
    private func buttonAnimation(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
    }
}


/* 플레이그라운드 다중 연산 테스트 소스 코드, 이어서 진행 예정!
 import Foundation

 let string = "1+2-3x4÷2"

 let operatorList : CharacterSet = ["+","-","x","÷"]


 let inputOperators = string.filter{$0.isNumber == false && $0 != "."}.map{String($0)}

 let numList = string.components(separatedBy: operatorList)

 let enumrated = inputOperators.enumerated()

 var num : Int = 0

 // 계산순서 인덱스 배열
 let calculateOrder = enumrated.filter{["x","÷"].contains($0.element)}.map{$0.offset} + enumrated.filter{["+","-"].contains($0.element)}.map{$0.offset}

 print(enumrated)
 print(calculateOrder)

 print(inputOperators)

 print(numList)

 for i in calculateOrder {
     
 }


 */
