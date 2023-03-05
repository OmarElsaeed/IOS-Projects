//
//  ViewController.swift
//  TicTacToe-Game
//
//  Created by Omar-Mac on 04/03/2023.
//

import UIKit

enum Turn{
    case Noughts
    case Cross
}

class ViewController: UIViewController {
    
            //MARK: - Variables
    var firstTurn: Turn = .Cross
    var currentTurn: Turn = .Cross
    var turnsCount = 0
    var borad = [UIButton]()
    var noughtsScore = 0, crossesScore = 0
    
    let noughtText = "O"
    let crossText = "X"
    
            //MARK: - Outlets
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnLabel.text = "X"
        initBoard()
        
    }
    
        // add all buttons on the board into an array called Board
    func initBoard(){
        borad.append(a1)
        borad.append(a2)
        borad.append(a3)
        borad.append(b1)
        borad.append(b2)
        borad.append(b3)
        borad.append(c1)
        borad.append(c2)
        borad.append(c3)
    }

    func checkVictory(for currentTurnText: String) -> Bool{
        
        
        if (a1.titleLabel?.text == currentTurnText && a2.titleLabel?.text == currentTurnText && a3.titleLabel?.text == currentTurnText){
            return true
        }
        else if (b1.titleLabel?.text == currentTurnText && b2.titleLabel?.text == currentTurnText && b3.titleLabel?.text == currentTurnText){
            return true
        }
        else if (c1.titleLabel?.text == currentTurnText && c2.titleLabel?.text == currentTurnText && c3.titleLabel?.text == currentTurnText){
            return true
        }
        else if (a1.titleLabel?.text == currentTurnText && b1.titleLabel?.text == currentTurnText && c1.titleLabel?.text == currentTurnText){
            return true
        }
        else if (a2.titleLabel?.text == currentTurnText && b2.titleLabel?.text == currentTurnText && c2.titleLabel?.text == currentTurnText){
            return true
        }
        else if (a3.titleLabel?.text == currentTurnText && b3.titleLabel?.text == currentTurnText && c3.titleLabel?.text == currentTurnText){
            return true
        }
        else if (a1.titleLabel?.text == currentTurnText && b2.titleLabel?.text == currentTurnText && c3.titleLabel?.text == currentTurnText){
            return true
        }
        else if (a3.titleLabel?.text == currentTurnText && b2.titleLabel?.text == currentTurnText && c1.titleLabel?.text == currentTurnText){
            return true
        }
        
     return false
    }
    
    func resultAlert(title: String){
        
        let alertController = UIAlertController(title: title, message: "Cross Score: \(crossesScore)\nNoughts Score: \(noughtsScore)", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "Reset", style: .default){_ in
            self.resetBoard()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    func fullBoard() -> Bool{
        
        return turnsCount == 9 ? true : false
    }
    
    func updateScore(for currentTurn: Turn){
        switch currentTurn{
        case .Cross:
            crossesScore += 1
        case .Noughts:
            noughtsScore += 1
        }
    }
    
    func resetBoard(){
        for button in borad {
            button.setTitle(nil, for: .normal)
            button.titleLabel?.text = nil
            button.isEnabled = true
        }
        
        turnsCount = 0  // reset turnCount which is responsible for counting number of played turns
    
        currentTurn = firstTurnToggle() // so different players can take turns to start the game
    }
    
    func updateCurrentTurn(){
        switch currentTurn {
            
        case .Noughts:
            currentTurn = .Cross
            turnLabel.text = "X"
            
        case .Cross:
            currentTurn = .Noughts
            turnLabel.text = "O"
        }
    }
    
    func addToBoard(_ sender: UIButton){
        
        switch currentTurn {
        case .Noughts:
            sender.setTitle(noughtText, for: .normal)
        case .Cross:
            sender.setTitle(crossText, for: .normal)
        }
    }
    // take turns between players
    func firstTurnToggle() -> Turn {
        switch firstTurn {
        case .Noughts:
            firstTurn = .Cross
            turnLabel.text = crossText
        case .Cross:
            firstTurn = .Noughts
            turnLabel.text = noughtText
        }
        return firstTurn
    }
    
                //MARK: - IBActions
    @IBAction func tapBoardAction(_ sender: UIButton) {
        
        addToBoard(sender) // put corss symbol "X" or nought symbol "O" on the board
        
        turnsCount += 1    //increment number of played turns by 1
        
        sender.isEnabled = false
        
        let currentTurnText = (currentTurn == .Cross ? crossText : noughtText)
        if checkVictory(for: currentTurnText) == true {
            let title = "\(currentTurnText) Wins"
            updateScore(for: currentTurn)
            resultAlert(title: title)
        }
        
        let boardIsFull = fullBoard()
        if boardIsFull == true{
            resultAlert(title: "Draw")
        }
        
        updateCurrentTurn()
    }
}

