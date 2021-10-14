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
    
    
    @IBOutlet weak var button_C: UIButton!
    
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
            button_C.setTitle("C", for: [])
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
    
    
    @IBOutlet weak var button2_5: UIButton!
    @IBOutlet weak var button2_6: UIButton!
    @IBOutlet weak var button3_5: UIButton!
    @IBOutlet weak var button3_6: UIButton!
    @IBOutlet weak var button4_2: UIButton!
    @IBOutlet weak var button4_3: UIButton!
    @IBOutlet weak var button4_4: UIButton!
    @IBOutlet weak var button5_2: UIButton!
    @IBOutlet weak var button5_3: UIButton!
    @IBOutlet weak var button5_4: UIButton!
    
    
    @IBAction func switchAC(_ sender: UIButton) {
        if sender.currentTitle! == "C"{
            sender.setTitle("AC", for: [])
        }
    }
    
    
    @IBAction func Switch2nd(_ sender: UIButton) {
        
        let defaultColor = UIColor.secondaryLabel
        let selectedColor = UIColor.systemGray
        
        if sender.backgroundColor == defaultColor
        {
            sender.backgroundColor = selectedColor
            sender.setTitleColor(UIColor.black, for: [])
            button2_5.setTitle("y^x", for: [])
            button2_6.setTitle("2^x", for: [])
            button3_5.setTitle("logy", for: [])
            button3_6.setTitle("log2", for: [])
            button4_2.setTitle("sin-1", for: [])
            button4_3.setTitle("cos-1", for: [])
            button4_4.setTitle("tan-1", for: [])
            button5_2.setTitle("sinh-1", for: [])
            button5_3.setTitle("cosh-1", for: [])
            button5_4.setTitle("tanh-1", for: [])
            
        }
        else
        {
            sender.backgroundColor = defaultColor
            sender.setTitleColor(UIColor.white, for: [])
            button2_5.setTitle("e^x", for: [])
            button2_6.setTitle("10^x", for: [])
            button3_5.setTitle("ln", for: [])
            button3_6.setTitle("log", for: [])
            button4_2.setTitle("sin", for: [])
            button4_3.setTitle("cos", for: [])
            button4_4.setTitle("tan", for: [])
            button5_2.setTitle("sinh", for: [])
            button5_3.setTitle("cosh", for: [])
            button5_4.setTitle("tanh", for: [])
            
        }
    }
    
    @IBAction func operatorTouch(_ sender: UIButton) {
        var operand:Double

        if digitOnDisplay.contains("e"){
            var substring = [String]()
            substring = digitOnDisplay.components(separatedBy: " ")
            operand = Double(substring.last!)!
        }
        else if digitOnDisplay == "Error!"{
            digitOnDisplay = "0"
            operand = 0
            
        }
        else{
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
                if (op == "cos-1" || op == "sin-1"||op == "tan-1"){
                    result = result / RadCorrect
                    result = (result * 10000000000000).rounded() / 10000000000000
                    
                }
                if result.isInfinite || result.isNaN || result == Double("-inf")
                {
                    digitOnDisplay = "Error!"
                }
                else if result == floor(result)//if the result is int,display without '.'
                {
                    digitOnDisplay = String(Int(result))
                }
                else
                {
                    digitOnDisplay = String(result)
                }
                    
            }
            if digitOnDisplay != "0"{
            button_C.setTitle("C", for: [])
            }
            inTypingMode = false;
        }
        
        
    }
}

