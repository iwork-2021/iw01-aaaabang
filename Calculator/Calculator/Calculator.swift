//
//  Calculator.swift
//  Calculator
//
//  Created by aaaabang on 2021/10/11.
//

import UIKit

var memory:Double = 0

class Calculator: NSObject {
    
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double,Double)->Double)
        case EqualOp
        case Constant(Double)
    }
    
    var operations = [
        "+": Operation.BinaryOp{
            (op1,op2) in
            return op1 + op2
        },
        
        "-": Operation.BinaryOp{
            (op1,op2) in
             return op1 - op2
        },
        
        "x": Operation.BinaryOp{
            (op1,op2) in
            return op1 * op2
        },
        
        "/": Operation.BinaryOp{
            (op1,op2) in
            return op1 / op2
        },
        
        "x^y": Operation.BinaryOp{
            (op1,op2) in
            return pow(op1, op2)
        },
        
        "EE":Operation.BinaryOp{
           op1,op2 in
           return op1 * pow(10,op2);
        },
        "=": Operation.EqualOp,
        
        "+/-": Operation.UnaryOp{
            op in
            return -op
        },
            
        "%": Operation.UnaryOp{
            op in
            return op / 100.0
        },
        
        "2nd": Operation.UnaryOp{
            op in
            return pow(2, op)
        },
        
        "x^2": Operation.UnaryOp{
            op in
            return pow(op, 2)
        },
        
        "x^3": Operation.UnaryOp{
            op in
            return pow(op,3)
        },
        
        "e^x": Operation.UnaryOp{
            op in
            return exp(op)
        },
        
        "10^x": Operation.UnaryOp{
            op in
            return pow(10,op)
        },
    
        "ln": Operation.UnaryOp{
            op in
            return log(op)
        },
        
        "log": Operation.UnaryOp{
            op in
            return log10(op)
        },
        
        "sin": Operation.UnaryOp{
            op in
            return sin(op)
        },
        
        "cos": Operation.UnaryOp{
            op in
            return cos(op)
        },
        
        "tan": Operation.UnaryOp{
            op in
            return tan(op)
        },
        
        "sinh": Operation.UnaryOp{
            op in
            return sinh(op)
        },
        
        "cosh": Operation.UnaryOp{
            op in
            return cosh(op)
        },
        
        "tanh": Operation.UnaryOp{
            op in
            return tanh(op)
        },
        
        "2√x": Operation.UnaryOp{
            op in
            return sqrt(op)
        },
        
        "3√x": Operation.UnaryOp{
            op in
            return cbrt(op)
        },
        
        "y√x": Operation.BinaryOp{
            (op1,op2) in
            return pow(op1,(1/op2))
        },
        
        "1/x": Operation.UnaryOp{
            op in
            return 1.0/op
        },
        
        "x!": Operation.UnaryOp{
            op in
            var sum:Int = 1
            func factorial (){
                var x = Int(op)
                for i in 1...x{
                    sum = sum * i
                }
            }
            factorial()
            return Double(sum)
        },
        
        "C": Operation.UnaryOp{
            _ in
            return 0
        },
        
        "mc": Operation.UnaryOp{
            op in
            memory = 0
            return op
        },
        
        "m+": Operation.UnaryOp{
            op in
            memory = memory + op
            return op
        },
        
        "m-": Operation.UnaryOp{
            op in
            memory = memory - op
            return op
        },
        
        "mr": Operation.UnaryOp{
            _ in
            return memory
        },
        
        //"mr":Operation.Constant(memory),
        
        "π":Operation.Constant(3.1415926),
        
        "e":Operation.Constant(2.71828),
        
        "Rand":Operation.Constant(drand48())
    ]
    
    struct Intermediate{
        var firstOp: Double
        var waitingOperation:(Double,Double) -> Double?
    }
    
    var pendingOp: Intermediate? = nil
    
    var waitingPendingOp = [Intermediate]()
    
    func performOnOperation(operation: String,operand: Double) ->Double?{
        
        if let op = operations[operation]{
            var res:Double? = nil
            switch op {
            case .BinaryOp(let function):
                
                if pendingOp != nil{
                    res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                    pendingOp = Intermediate(firstOp: res!, waitingOperation: function)
                    return res
                }
                else{
                    pendingOp = Intermediate(firstOp: operand, waitingOperation: function)
                }
                return res
            case .Constant(let value):
                    //print(memory)
                return value;
            case .EqualOp:
                var res: Double? = nil
                if pendingOp != nil{//if there is Operation
                res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                pendingOp = nil
                }
                return res
            case.UnaryOp(let function):
                if operation == "C"
                {
                    if operand == 0//if digitOnDisplay has been cleared,clear the operation waiting
                    {
                        pendingOp = nil
                    }
                }
                
                res = function(operand)
                res = (res! * 1000000000000000).rounded() / 1000000000000000
                res = Double(res ?? 0)
                return res
            }
        }
        else if operation == "("{
                if pendingOp != nil{
                    waitingPendingOp.append(pendingOp!)
                    pendingOp = nil
                }
        }
        else if operation == ")"{
            var res:Double? = nil
            if pendingOp != nil{//if there is Operation
                res = pendingOp!.waitingOperation(pendingOp!.firstOp,operand)
                if waitingPendingOp.isEmpty == false{
                    pendingOp = waitingPendingOp.removeLast()
                }
                else{
                    pendingOp = nil
                }
            }
            
            return res
        }
        
        return nil
    }
}
