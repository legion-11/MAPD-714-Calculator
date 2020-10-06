//
//  ViewController.swift
//  Calculator
//
//  Created by Dmytro Andriichuk
//  Student number 301132978
//  on 26.09.2020.
//
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var inputLable: UILabel!
    
    var splitedInput = ["0"]
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let number = sender.currentTitle!;
        let last = splitedInput.last;
        
        if (last == "0"){
            splitedInput[splitedInput.endIndex-1] = number;
        }else if (["✕", "%", "+", "–", "÷"].contains(last)){
            splitedInput.append(number)
        }else {
            splitedInput.append(splitedInput.removeLast() + number);
        }
        inputLable.text! = splitedInput.joined();
    }
    

    func calculate(_ first: Double, _ second: Double, _ operation:String) -> String{
        switch operation {
        case "%":
             return String(Int(first) % Int(second))
        case "+":
            return String (first+second)
        case "–":
            return String (first-second)
        case "÷":
            if second == 0.0 {return "error"}
            return String (first/second)
        case "✕":
            return String (first*second)
        default:
            print("error")
            return "error"
        }
    }
    
    @IBAction func OperatorPressed(_ sender: UIButton) {
        let operatorSign = sender.currentTitle!;
        if (["✕", "%", "+", "–", "÷"].contains(splitedInput.last)){
            splitedInput[splitedInput.endIndex-1] = operatorSign;
        }else{
            splitedInput.append(operatorSign);
        }
        inputLable.text! = splitedInput.joined();
    }
    
    @IBAction func pressChangeSign(_ sender: UIButton) {
        if !(["✕", "%", "+", "–", "÷"].contains(splitedInput.last) || splitedInput.last != "0"){
            if (splitedInput.last!.first != "-"){
                splitedInput.append("-" + splitedInput.removeLast());
            }else{
                splitedInput[splitedInput.endIndex-1].removeFirst();
            }
            inputLable.text! = splitedInput.joined();
        }
    }
    
    @IBAction func pressBackspace(_ sender: UIButton) {
        if (splitedInput.last!.count == 1){
            splitedInput.removeLast();
            if (splitedInput.count == 0){
                splitedInput.append("0")
            }
        }else{
            splitedInput[splitedInput.endIndex-1].removeLast();
        }
        inputLable.text! = splitedInput.joined();
    }
    
    @IBAction func pressDot(_ sender: UIButton) {
        let last = splitedInput.last;
        
        if (["✕", "%", "+", "–", "÷"].contains(last)){
            splitedInput.append("0.")
        }else if !((last?.contains("."))!){
            splitedInput.append(splitedInput.removeLast() + ".");
        }
        inputLable.text! = splitedInput.joined();
    }
    
    @IBAction func pressEquals(_ sender: UIButton) {
        if (["✕", "%", "+", "–", "÷"].contains(splitedInput.last)){
            splitedInput.removeLast();
        }
        var result = Double(splitedInput[0]);
        for i in stride(from: 2, to: splitedInput.count, by: 2) {
            let tmp = calculate(Double(result!), Double(splitedInput[i])!, splitedInput[i-1]);
            if !(tmp == "error"){
                result! = Double(tmp)!;
                print(i, result!)
            }else{
                print("error");
                resultLable.text! = "error";
            }
        }
        print(result!)
        resultLable.text! = String(result!);
    }
    
    @IBAction func pressAllClear(_ sender: UIButton) {
        splitedInput = ["0"]
        inputLable.text! = splitedInput.joined();
    }
}

