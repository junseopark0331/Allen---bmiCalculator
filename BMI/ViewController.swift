//
//  ViewController.swift
//  BMI
//
//  Created by 박준서 on 2023/04/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    
    var bmi: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    
    func makeUI(){
        heightTextField.delegate = self
        weightTextField.delegate = self
        
        mainLabel.text = "키와 몸무게를 입력해 주세요"
        calculateButton.clipsToBounds = true
        calculateButton.layer.cornerRadius = 5
        calculateButton.setTitle("BMI 계산하기", for: .normal)
        heightTextField.placeholder = "cm 단위로 입력해주세요"
        weightTextField.placeholder = "kg 단위로 입력해주세요"
        
        
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        // BMI 결과 값을 뽑아냄
        
        guard let height = heightTextField.text,
            let weight = weightTextField.text else {return}
        
        bmi = calculateBMI(height: height, weight: weight)
        
    }
    
    func getBackgroundColor() -> UIColor {
        guard let bmi = bmi else { return UIColor.black }
        switch bmi {
        case ..<18.6:
            return UIColor(displayP3Red: 22/255, green: 231/255, blue: 207/255, alpha: 1)
        case 18.6..<23.0:
            return UIColor(displayP3Red: 212/255, green: 251/255, blue: 121/255, alpha: 1)
        case 23.0..<25.0:
            return UIColor(displayP3Red: 218/255, green: 127/255, blue: 163/255, alpha: 1)
        case 25.0..<30.0:
            return UIColor(displayP3Red: 255/255, green: 150/255, blue: 141/255, alpha: 1)
        case 30.0...:
            return UIColor(displayP3Red: 255/255, green: 100/255, blue: 78/255, alpha: 1)
        default:
            return UIColor.black
        }
    }
   
    func getBMIAdviceString() -> String {
        guard let bmi = bmi else { return "" }
        switch bmi {
        case ..<18.6:
            return "저체중"
        case 18.6..<23.0:
            return "표준"
        case 23.0..<25.0:
            return "과체중"
        case 25.0..<30.0:
            return "중도비만"
        case 30.0...:
            return "고도비만"
        default:
            return ""
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if heightTextField.text == "" || weightTextField.text == ""{
            mainLabel.text = "키와 몸무게를 입력하셔야만 합니다!!!"
            mainLabel.textColor = UIColor.red
            return false
        }
        mainLabel.text = "키와 몸무게를 입력해 주세요!"
        mainLabel.textColor = UIColor.black
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSecondVC"{
            let secondVC = segue.destination as! SecondViewController
            
            secondVC.bmiNumber = self.bmi
            secondVC.adviceString = getBMIAdviceString()
            secondVC.bmiColor = getBackgroundColor()
            
        }
    
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    func calculateBMI(height: String, weight: String) -> Double{
        guard let h = Double(height), let w = Double(weight) else {return 0.0}
        var bmi = w / (h * h) * 10000
//        print("BMI결과값 (반올림 하기 전) : \(bmi)")
        bmi = round(bmi * 10) / 10
//        print("BMI결과값 (반올림 한 후) : \(bmi)")
        return bmi
    }

}


extension ViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if Int(string) != nil || string == ""{
            return true //글자 입력을 허용
        }
        return false // 글자 입력 허용하지 않음
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 두개의 텍스트필드를 모두 종료 (키보드 내려가기)
        if heightTextField.text != "", weightTextField.text != ""{
            weightTextField.resignFirstResponder()
            return true
        }else if heightTextField.text != ""{
            weightTextField.becomeFirstResponder()
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
    
}
