//
//  ViewController.swift
//  Calculator
//
//  Created by aaaabang on 2021/10/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text! = "0"
    }

    
    
    var digitOnDisplay : String{
        get{
            return self.displayLabel.text!
        }
        
        set{
            self.displayLabel.text! = newValue
        }
    }
    
    var inTypingMode = false;
    
    @IBAction func numberTouch(_ sender: UIButton) {
        if inTypingMode {
            digitOnDisplay = digitOnDisplay + sender.currentTitle!
        }
        else {//重新输入新的值
            if digitOnDisplay.contains("e"){
               digitOnDisplay.removeLast()
                digitOnDisplay += sender.currentTitle!
                
            }
            else
            {
                digitOnDisplay = sender.currentTitle!
            }
            inTypingMode = true;
        }
    }
    
    @IBOutlet weak var radDisplayLabel: UILabel!
    
    var radOnDisplay : String{
        get{
            return self.radDisplayLabel.text!
        }
        
        set{
            self.radDisplayLabel.text! = newValue
        }
    }
    let calculator = Calculator()
    var RadMode = false
    var RadCorrect:Double = Double.pi/180
    /*切换Rad\Deg模式*/
    @IBAction func SwitchRad(_ sender: UIButton) {
        if sender.currentTitle == "Rad"
        {
            RadMode = true
            sender.setTitle("Deg", for: [])
            RadCorrect = 1
            radOnDisplay = "Rad"
        }
        else
        {
            RadMode = false
            sender.setTitle("Rad", for: [])
            RadCorrect = Double.pi/180
            radOnDisplay = ""
        }
    }
    
    @IBAction func operatorTouch(_ sender: UIButton) {
        var operand:Double

        if digitOnDisplay.contains("e"){
            var substring = [String]()
            substring = digitOnDisplay.components(separatedBy: " ")
            operand = Double(substring.last!)!
        }
        else
        {
            operand = Double(digitOnDisplay)!
        }
        
        if let op = sender.currentTitle{
            
            if op == "cos" || op == "sin"||op == "tan"{
                operand = operand * RadCorrect
            }
            
            if op == "EE"{
                digitOnDisplay = digitOnDisplay + " e 0"
            }
            if var result = calculator.performOnOperation(operation: op, operand: operand)
            {
                if (op == "cos^-1" || op == "sin^-1"||op == "tan^-1"){
                    result = result * RadCorrect
                }
                if result == Double(Int(result))//if the result is int,display without '.'
                {
                    digitOnDisplay = String(Int(result))
                }
                else
                {
                    digitOnDisplay = String(result)
                }
                    
            }
            inTypingMode = false;
        }
        
        
    }
}

