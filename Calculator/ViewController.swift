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
    
    // return last element of splitedInput
    func getLast() -> String {return splitedInput.last!}
    // removes first char of last element in splitedInput
    func removeLastStart() {splitedInput[splitedInput.endIndex-1].removeFirst()}
    // removes last char of last element in splitedInput
    func removeLastEnd() {splitedInput[splitedInput.endIndex-1].removeLast()}
    // set last element of splitedInput
    func setLast(_ str: String) {splitedInput[splitedInput.endIndex-1] = str}
    // adds char at the end of last element of splitedInput
    func addToLast(_ str: String) {splitedInput[splitedInput.endIndex-1] += str}
    // adds char at the start of last element of splitedInput
    func addToLastStart(_ str: String) {splitedInput[splitedInput.endIndex-1] = str + splitedInput[splitedInput.endIndex-1]}
    // counts how many str elemnts we have in arr
    func getCountOf(_ str:String, _ arr:Array<String>) -> Int{
        return arr.filter{$0 == str}.count
    }
    // all supported operations
    let operations = ["✕", "%", "+", "–", "÷"]
    // returns true if element is operation sign
    func isOperation(_ str: String) -> Bool{
        return operations.contains(str)
    }
    // all supported trigonometric operations
    let treg = ["sin(", "cos(", "tan("]
    // returns true if element is trigonometric operation sign
    func isTreg(_ str: String) -> Bool{
        return treg.contains(str)
    }
    // transforms String in Double
    func getOperand(_ str: String) -> Double {
        if (str == "π"){ return Double.pi }
        return Double(str)!
    }
    
    // calculate operation between two operands
    func calculate1Operation(_ first: Double, _ second: Double, _ operation:String) -> String{
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
    // calculate trigonometric operation, if inner body has other operation calculetes them first
    func calcTreg(_ treg: String ,_ sub: Array<String>) -> String {
        if (sub.count == 0){return "error"}
        let tmp = calculateSubArray(sub)
        if (tmp == "error"){return "error"}
        switch treg {
        case "sin(":
            return String(sin(Double(tmp)!))
        case "cos(":
            return String(cos(Double(tmp)!))
        default:
            return String(tan(Double(tmp)!))
        }
    }
    // return the index of scope for the trigonometric operation at start index
    func getScopeIndex(_ start: Int, _ arr: Array<String>) -> Int {
        var counter = 0
        for i in start..<arr.endIndex{
            if (isTreg(arr[i])){ counter += 1}
            else if (arr[i] == ")") {counter -= 1}
            if (counter == 0){return i}
        }
        return arr.endIndex
    }
    // calculates operations in a recursive way
    // ex: 1+sin(1+2*1)
    // res = 1
    // res = res + sin(2+2*1) where 2+2*1 == calculateSubArray(2+2*1)
    //     res2 = 2
    //     res2 = res+2
    //     res2 = res*1
    // res = res + sin(res2)
    func calculateSubArray(_ arr: Array<String>) -> String {
        print(arr)
        var curIndex = 0
        var res: Double
        
        if (isTreg(arr[curIndex])){
            let scopeIndex = getScopeIndex(curIndex, arr)
            if (curIndex+1 > scopeIndex) {return "error"}
            let sub = Array(arr[curIndex+1..<scopeIndex])
            let tmp = calcTreg(arr[curIndex], sub)
            if (tmp == "error"){
                return "error"
            }
            res = Double(tmp)!
            curIndex = scopeIndex + 2
        }else{
            res = getOperand(arr[curIndex])
            curIndex += 2
        }
        
        var nextIndex: Int
        var tmp: String
        while (curIndex < arr.endIndex) {
            if (isTreg(arr[curIndex])){
                let scopeIndex = getScopeIndex(curIndex, arr)
                if (curIndex+1 > scopeIndex) {return "error"}
                let sub = Array(arr[curIndex+1..<scopeIndex])
                tmp = calcTreg(arr[curIndex], sub)
                if (tmp == "error"){return "error"}
                nextIndex = scopeIndex + 2
            }else{
                tmp = arr[curIndex]
                nextIndex = curIndex + 2
            }
            
            tmp = calculate1Operation(res, getOperand(tmp), arr[curIndex - 1])
            if (tmp == "error"){return "error"}
            curIndex = nextIndex
            res = Double(tmp)!
        }
        return String(res)
    }
    
    /*
     calculates result of input, if there are any error do not updating result lable
     */
    func calculateFull(){
        let res = calculateSubArray(splitedInput)
        if res == "error"{return}
        
        if (res.contains("e")){
            resultLable.text! = "=" + res
            return
        }
        
        //formate to natural form
        let strRes = String(format: "%.9f", Double(res)!)
        var zeroTrunc = strRes.replacingOccurrences(of: "0*$", with: "", options: .regularExpression)
        if (zeroTrunc.last == "."){zeroTrunc.removeLast()}
        resultLable.text! = "=" + zeroTrunc
    }
    
    /*
     listener to 0-9 buttons
     appends splitedInput with new operand
     or modify last one, if the last element in array is operand
     won't allow input integer that starts with 0
     */
    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        let last = getLast()
        
        if (last == "0"){
            setLast(number)
        }else if (isOperation(last) || isTreg(last)){
            splitedInput.append(number)
        }else if (last != "π" && last != ")"){
            addToLast(number)
        }
        inputLable.text! = splitedInput.joined()
        calculateFull()
    }
    
    /*
     listener to ✕, %, +, –, ÷ buttons
     appends splitedInput with new operator
     or modify one, if the last element in array is operator
     */
    @IBAction func OperatorPressed(_ sender: UIButton) {
        let operatorSign = sender.currentTitle!
        if (isOperation(getLast())){
            setLast(operatorSign)
        }else if (isTreg(getLast())){
            return
        }else{
            splitedInput.append(operatorSign)
        }
        inputLable.text! = splitedInput.joined()
    }
    
    /*
     listener to +/- button
     changes the sign of last operator if it goes last in splitedInput and not equals 0
     */
    @IBAction func pressChangeSign(_ sender: UIButton) {
        if !(isOperation(getLast()) || Double(getLast()) == 0 || isTreg(getLast()) || getLast() == ")" ){
            if (getLast().first != "-"){
                addToLastStart("-")
            }else{
                removeLastStart()
            }
            inputLable.text! = splitedInput.joined()
            calculateFull()
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
        if (getLast().count == 1 || isTreg(getLast())){
            splitedInput.removeLast()
        }else{
            removeLastEnd()
            if (getLast() == "-"){
                splitedInput.removeLast()
            }
        }
        if (splitedInput.count == 0){
            splitedInput.append("0")
        }
        inputLable.text! = splitedInput.joined()
        calculateFull()
    }
    
    /*
     listener to . (dot) button
     inputs dot in last operator if it don't have one
     if last element in splitedInput is operation sign than appends it with "0."
     */
    @IBAction func pressDot(_ sender: UIButton) {
        let last = getLast()
        
        if (isOperation(last) || isTreg(last)){
            splitedInput.append("0.")
        }else if (!(last.contains(".")) || last == "π" || last == ")"){
            addToLast(".")
        }
        inputLable.text! = splitedInput.joined()
    }
    
    /*
     listener to = (equals) button
     rewrite splitedInput with text of resultLable if it is in normal form
     */
    @IBAction func pressEquals(_ sender: UIButton) {
        //remove = (equals) char
        var resultStr = resultLable.text!
        resultStr.removeFirst()
        
        if (resultStr.contains("e")){return}
        
        splitedInput = [resultStr]
        inputLable.text! = splitedInput.joined()
    }
    
    /*
     listener to AC button
     rewrite splitedInput with ["0"]
     do not affect resultLable in case if user wants ro copy result in input
     */
    @IBAction func pressAllClear(_ sender: UIButton) {
        splitedInput = ["0"]
        inputLable.text! = splitedInput.joined()
    }
    
    /*
     listener to π button
     adds π to splitedInput
     */
    @IBAction func pressPi(_ sender: UIButton) {
        if (isOperation(getLast()) || isTreg(getLast())){ splitedInput.append("π") }
        else if (getLast() == "0"){ setLast("π") }
        inputLable.text! = splitedInput.joined()
        calculateFull()
    }
    /*
     add trigonometric operation to splited input, supports compound calculations
     */
    @IBAction func pressTrigonomFunc(_ sender: UIButton) {
        let operatorSign = sender.currentTitle!
        if (isOperation(getLast()) || isTreg(getLast())){
            splitedInput.append(operatorSign + "(")
        }else if (getLast() == "0"){
            setLast(operatorSign + "(")
        }
        inputLable.text! = splitedInput.joined()
    }
    /*
     add closed scope if the number of trigonometric operations are bigger than number of scopes
     */
    @IBAction func presClosedScope(_ sender: UIButton) {
        if (!isOperation(getLast()) && !isTreg(getLast())){
            if (getCountOf("tan(", splitedInput) + getCountOf("cos(", splitedInput) + getCountOf("sin(", splitedInput) - getCountOf(")", splitedInput) > 0){
                splitedInput.append(")")
                inputLable.text! = splitedInput.joined()
                calculateFull()
            }
        }
    }
}

