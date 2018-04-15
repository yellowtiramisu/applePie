//
//  ViewController.swift
//  Apple Pie
//
//  Created by Lorenzo G. on 2018-04-15.
//  Copyright © 2018 Rose Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var listOfWords = ["apple", "lorenzo", "gulsel", "home"]
    let incorrectMovesAllowed = 7
    var totalWins = 0 {
        didSet { // property observers: whenever these are updated, new round!
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }

    var currentGame: Game!
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable // whatever the bool says, that's what the buttons do
        }
    }
    
    func newRound() {
        // function that runs whenever a new round starts: inits things around
        // and creates a new instance of Game
        
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false) // we disable the keyboard for good.
        }
    }
    
    func updateUI() {
        // function which updates the screen with updated game information
        
        // taking the letters from the formatted word, putting them in a list,
        // and restitching them together with a space in between (legibility)
//        var letters = [String]()
//        for letter in currentGame.formattedWord {
//            letters.append(String(letter))
//        }
        
        // let's do that with a map
        let letters = currentGame.formattedWord.map {String($0)}
        
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        
    }
    
    // this function updates losses, wins, or just lets the player go on
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // we need UIButton as sender so that we can access its
        // title property, something the Any type does not have.
        // we need access to it to determine which button is to
        // be disabled
        sender.isEnabled = false
        
        // getting letter from button pressed and normalising it
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        
        // feeding that letter into the playerGuessed function
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }

}

