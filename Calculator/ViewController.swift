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
    
    
    @IBOutlet weak var inputLable: UILabel!
    
    var initTyping = true;
    var startedWritingOperand = true;
    var pointTyped = false;
    var firstOperand: Double = 0
    var currentInputedOperand: String = "";
    
    func addString(_ str: String){
        currentInputedOperand += str
        inputLable.text! += str;
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let number = sender.currentTitle!;
        
        if !startedWritingOperand{
            addString(number);
        }else if number != "0"{
            if initTyping {
                inputLable.text! = "";
                initTyping = false
            }
            addString(number);
            startedWritingOperand = false;
            
        }
    }
    
    @IBAction func OperatorPressed(_ sender: UIButton) {
        firstOperand = Double(currentInputedOperand)!;
        currentInputedOperand = "";
        startedWritingOperand = true
        
    }
}

