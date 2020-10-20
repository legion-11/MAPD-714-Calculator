//
//  ViewController.swift
//  Calculator
//
//  Created by Dmytro Andriichuk
//  Student number 301132978
//  on 26.09.2020.
//
//Simple calculator project without operations priority,
//so + operation calculated before * if it's goes first
//

import UIKit
//layer.cornerRadius   F25B23
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var resultLable: UILabel!
    @IBOutlet weak var inputLable: UILabel!
    
    var splitedInput = ["0"]  // array of strings in order operand, operator exmple: ["1", "+", "1.232", "-"...]
    
    // calculate operation between two operands
    func calculate1Operation(_ first: Double, _ second: Double, _ operation:String) -> String{
        switch operation {
        case "%":
            return String(Int(first) % Int(second));
        case "+":
            return String (first+second);
        case "–":
            return String (first-second);
        case "÷":
            if second == 0.0 {return "error"}
            return String (first/second);
        case "✕":
            return String (first*second);
        default:
            print("error");
            return "error"
        }
    }
    
    /*
     compound calculation in for loop by reasigning result variable with new calculation
     between result and next operand in array
     example splitedInput = ["1",+,"2",-,"3"]
     1 result = 1;
     2 result = result + 2; // 3
     3 result = result - 3; // 0
     */
    func calculateFull(){
        var result = Double(splitedInput[0]);
        for i in stride(from: 2, to: splitedInput.count, by: 2) {
            let tmp = calculate1Operation(Double(result!), Double(splitedInput[i])!, splitedInput[i-1]);
            if !(tmp == "error"){
                result! = Double(tmp)!;
            }else{
                print("error");
                resultLable.text! = "error";
                return
            }
        }
        if (String(result!).contains("e")){
            resultLable.text! = "=" + String(result!);
            return
        }
        //formate to natural form
        let strRes = String(format: "%.9f", result!);
        var zeroTrunc = strRes.replacingOccurrences(of: "0*$", with: "", options: .regularExpression);
        if (zeroTrunc.last == "."){zeroTrunc.removeLast()}
        resultLable.text! = "=" + zeroTrunc;
    }
    
    /*
     listener to 0-9 buttons
     appends splitedInput with new operand
     or modify last one, if the last element in array is operand
     won't allow input integer that starts with 0
     */
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!;
        let last = splitedInput.last;
        
        if (last == "0"){
            splitedInput[splitedInput.endIndex-1] = number;
        }else if (["✕", "%", "+", "–", "÷"].contains(last)){
            splitedInput.append(number);
        }else {
            splitedInput[splitedInput.count-1] += number;
        }
        inputLable.text! = splitedInput.joined();
        calculateFull();
    }
    
    /*
     listener to ✕, %, +, –, ÷ buttons
     appends splitedInput with new operator
     or modify one, if the last element in array is operator
     */
    @IBAction func OperatorPressed(_ sender: UIButton) {
        let operatorSign = sender.currentTitle!;
        if (["✕", "%", "+", "–", "÷"].contains(splitedInput.last)){
            splitedInput[splitedInput.endIndex-1] = operatorSign;
        }else{
            splitedInput.append(operatorSign);
        }
        inputLable.text! = splitedInput.joined();
    }
    
    /*
     listener to +/- button
     changes the sign of last operator if it goes last in splitedInput and not equals 0
     */
    @IBAction func pressChangeSign(_ sender: UIButton) {
        if !(["✕", "%", "+", "–", "÷"].contains(splitedInput.last) || Double(splitedInput.last!) == 0){
            if (splitedInput.last!.first != "-"){
                splitedInput[splitedInput.count-1] = "-" + splitedInput[splitedInput.count-1];
            }else{
                splitedInput[splitedInput.endIndex-1].removeFirst();
            }
            inputLable.text! = splitedInput.joined();
            calculateFull();
        }
    }
    
    /*
     listener to <- (backspace) button
     depending on what goes last in splitedInput
     removes last char of last operator (if it has more than 1 digit, otherwise removes it completely)
     or removes last operation from splitedInput
     not allowing to have empty splitedInput
     */
    @IBAction func pressBackspace(_ sender: UIButton) {
        if (splitedInput.last!.count == 1){
            splitedInput.removeLast();
        }else{
            splitedInput[splitedInput.endIndex-1].removeLast();
            if (splitedInput[splitedInput.endIndex-1] == "-"){
                splitedInput.removeLast();
            }
        }
        if (splitedInput.count == 0){
            splitedInput.append("0");
        }
        inputLable.text! = splitedInput.joined();
        calculateFull();
    }
    
    /*
     listener to . (dot) button
     inputs dot in last operator if it don't have one
     if last element in splitedInput is operation sign than appends it with "0."
     */
    @IBAction func pressDot(_ sender: UIButton) {
        let last = splitedInput.last;
        
        if (["✕", "%", "+", "–", "÷"].contains(last)){
            splitedInput.append("0.");
        }else if !((last?.contains("."))!){
            splitedInput[splitedInput.count-1] += ".";
        }
        inputLable.text! = splitedInput.joined();
    }
    
    /*
     listener to = (equals) button
     rewrite splitedInput with text of resultLable if it is in normal form
     */
    @IBAction func pressEquals(_ sender: UIButton) {
        //remove = (equals) char
        var resultStr = resultLable.text!;
        resultStr.removeFirst()
        
        if (resultStr.contains("e")){return}
        
        splitedInput = [resultStr];
        inputLable.text! = splitedInput.joined();
    }
    
    /*
     listener to AC button
     rewrite splitedInput with ["0"]
     do not affect resultLable in case if user wants ro copy result in input
     */
    @IBAction func pressAllClear(_ sender: UIButton) {
        splitedInput = ["0"]
        inputLable.text! = splitedInput.joined();
    }
}

