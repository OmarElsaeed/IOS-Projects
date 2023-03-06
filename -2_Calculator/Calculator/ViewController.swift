//
//  ViewController.swift
//  Calculator
//
//  Created by Omar-Mac on 06/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var workings = ""
    var result: Double!
   
    @IBOutlet weak var calculatorWorkings: UILabel!
    @IBOutlet weak var calculatorResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clearAll()
    }

    @IBAction func allClearTap(_ sender: UIButton) {
        clearAll()
    }
    
    func clearAll(){
        workings = ""
        calculatorWorkings.text = workings
        calculatorResult.text = ""
    }
    
    @IBAction func backTap(_ sender: UIButton) {
        if !workings.isEmpty {
            workings.removeLast()
            calculatorWorkings.text = workings
        }
    }
    
    @IBAction func ButtonTap(_ sender: UIButton) {
        let symbol = (sender.titleLabel?.text)!
        switch symbol{
        case ".","%","/","-","+","0","1","2","3","4","5","6","7","8","9":
            addToWorkings(value: symbol)
        case "X":
            addToWorkings(value: "*")
            
        default:
            return
        }
    }
        
        func addToWorkings(value: String){
            
            workings += value
            calculatorWorkings.text = workings
        }
        
        @IBAction func equalTap(_ sender: UIButton) {
            formatResult()
            if validInput(){
                let expression = NSExpression(format: workings)
                let result = expression.expressionValue(with: nil, context: nil) as! Double // let the swift standard library do the math for us
                let formatedResult = formatResult(result: result)
                self.result = Double(formatedResult)
                if self.result.truncatingRemainder(dividingBy: 1) == 0{
                    workings = String(Int(self.result))
                }
                else {
                    workings = String(self.result)
                }
                
                calculatorResult.text = formatedResult
            }
            
            else{
                let ac = UIAlertController(title: "Invalid Input", message: "can't do math on the given input", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(ac, animated: true)
                
            }
            
            
        }
    func formatResult(result: Double) -> String{
        
        if result.truncatingRemainder(dividingBy: 1) == 0{
            //which means that the numbers after decimal point are 0 "ex:43.00" which means that the result is whole number
            return String(format: "%.0f", result)
        }
        else {
            return String(format: "%.2f", result)
        }
    }
    func formatResult(){
        workings = workings.replacingOccurrences(of: "%", with: "*0.01")
    }
    
    func validInput() -> Bool{
        var specialCharIndices = [Int]()
        var index = 0
        for char in workings{
            if specialChar(char: char){
                specialCharIndices.append(index)
            }
            index += 1
        }
        if workings.count < 3{
            return false
        }
        
        if specialChar(char: workings.first!) || specialChar(char: workings.last!){
            return false
        }
        var previousIndex = -1
        for index in specialCharIndices{
            // check if there is two operands "special char" are comming one after another
            if index != -1 && index - previousIndex == 1{
                return false
            }
            previousIndex = index
        }
        
        return true
        
    }
    
    func specialChar(char: Character) -> Bool{
        
        switch char{
        case "*", "/", "+", "-":
            return true
        default:
            return false
        }
        
    }
        
    }

