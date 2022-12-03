//  ViewController.swift
//  Challenge3 HangMan Game Guessing the Letters of a Word
//  Created by Ahmed Shaban on 31/07/2022.

import UIKit

class ViewController: UIViewController {
    var level = 1 {
        didSet {
            levelCounter.text = "Level: \(level) "
        }
    }
    var score = 0 {
        didSet {
            scoreCounter.text = "Score: \(score) "
        }
    }
    var number = 0 {
        didSet {
            clueLabel.text = clues[number]
            hiddenAnswer = solutions[number]
            answerLabel.text = ""
            for _ in 0..<hiddenAnswer.count {
                answerLabel.text? += "*"
            }
        }
    }
    var failedTries = 0 {
        didSet {
            failedTriesCounter.text = "Failed Tries: \(failedTries) / 7"
        }
    }
    var solutions = [String]()
    var clues = [String]()
    var hiddenAnswer: String = ""
    @IBOutlet var levelCounter: UILabel!
    @IBOutlet var scoreCounter: UILabel!
    @IBOutlet var failedTriesCounter: UILabel!
    @IBOutlet var clueLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBAction func ResetLevel(_ sender: UIButton) {
        ResetGame()
    }
    @IBAction func submitLetter(_ sender: UIButton) {
        if let answer = textField?.text {
            if answer.count == 1 {
                loadNext(letter: answer.uppercased())
                textField.text = ""
            } else {
                let ac = UIAlertController(title: "Note", message: "Enter one letter only", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
                present(ac, animated: true)
                textField.text = ""
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
        updateLables()
     }
    func ResetGame() {
        level = 1
        score = 0
        number = 0
        failedTries = 0
        loadLevel()
        updateLables()
    }
    func loadLevel() {
        clues.removeAll()
        solutions.removeAll()
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0] // HA|UNT|ED
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutions.append(String(solutionWord))
                    let clue = parts[1] // Ghosts in residence
                    clues.append(String(clue)) // ["Ghosts in residence"]
                }
            }
        }
    }
    func updateLables() {
        levelCounter.text = "Level: \(level) "
        scoreCounter.text = "Score: \(score) "
        failedTriesCounter.text = "Failed Tries: \(failedTries) / 7"
        clueLabel.text = clues[number]
        hiddenAnswer = solutions[number]
        answerLabel.text = ""
        for _ in 0..<hiddenAnswer.count {
            answerLabel.text? += "*"
        }
    }
    func loadNext(letter: String) {
        var starsArray = [Character]()
        for char in answerLabel.text! {
            starsArray.append(char)
        }
        var hiddenAnswerArray = [Character]()
        for char in hiddenAnswer {
            hiddenAnswerArray.append(char)
        }
        if hiddenAnswer.contains(letter) {
            for (num, char) in hiddenAnswerArray.enumerated() {
                if char == Character(letter) {
                    starsArray[num] = hiddenAnswerArray[num]
                }
            }
            answerLabel.text = String(starsArray)
            if answerLabel.text?.contains("*") == false {
                score += 1
                if score == 7 {
                    number = 0
                    level += 1
                    loadLevel()                     
                }
                if score == 14 {
                    let ac = UIAlertController(title: "Victory!", message: "You Passed the Two available levels! Congratulations!", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Great", style: .default))
                    present(ac, animated: true)
                    ResetGame()
                }
                if number < 6 {
                    number += 1
                }
            }
        } else {
            if failedTries < 6 {
                failedTries += 1
                let ac = UIAlertController(title: "Wrong!", message: "You entered a wrong letter", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try Again", style: .default))
                present(ac, animated: true)
            } else {
                ResetGame()
                let ac = UIAlertController(title: "Fail!", message: "You consumed all available tries", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try Again", style: .default))
                present(ac, animated: true)
            }
        }
    }
}
    
    
    
    
    


