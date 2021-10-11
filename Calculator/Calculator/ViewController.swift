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
        self.displayLabel.text! = "00"
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
            digitOnDisplay = sender.currentTitle!
            inTypingMode = true;
        }
    }
    
    
    @IBAction func operatorTouch(_ sender: UIButton) {
        inTypingMode = false;
        
    }
}

