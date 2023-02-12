//
//  ContentView.swift
//  PracticeMultiplication
//
//  Created by Chase Martin on 2/11/23.
//

import SwiftUI

struct ContentView: View {
	@State private var settingUpGame = true
	@State private var numberSelection = 2
	@State private var numberOfQuestions = 1
	@State private var questionsAnswered = 0
	@State private var questionsCorrect = 0
	@State private var randomNumber = Int.random(in: 2...12)
	
	@State private var showingSetUpAlert = false
	@State private var setUpAlertTitle = ""
	@State private var setUpAlertMessage = ""
	
	@State private var showingGameEndAlert = false
	@State private var gameEndAlertMessage = ""
	
	@State private var answer: Int? = nil
	@FocusState private var answerIsFocused: Bool
	
	private var questionsNum: Int {
		numberOfQuestions * 5
	}
	
	var body: some View {
		if settingUpGame {
			NavigationView {
				Form{
					Section {
						TextField("Please enter desired number to practice", value: $numberSelection, format: .number)
							.keyboardType(.numberPad)
					} header: {
						Text("Enter the number you want to practice")
					}
					
					Section {
						Picker("Select the number of questions", selection: $numberOfQuestions){
							ForEach(1...4, id: \.self) {
								Text(($0 * 5), format: .number)
							}
						}
					} header: {
						Text("Select the number of questions")
					}
					
					Button("Begin quiz", action: startGame)
						.buttonStyle(PlainButtonStyle())
				}.navigationTitle("Set up your game")
					.alert(setUpAlertTitle, isPresented: $showingSetUpAlert) {
					} message: {
						Text(setUpAlertMessage)
					}
			}
		}
		else {
			NavigationView{
				Form{
					Section {
						VStack {
							Text("\(numberSelection) x \(randomNumber) =")
							TextField("Enter your answer", value: $answer, format: .number)
								.keyboardType(.numberPad)
								.focused($answerIsFocused)
							Button(action: answerSubmitted) {
								Text("Submit")
							}
						}
						.padding(30)
					}
					
					Section {
						Text("\(questionsCorrect) correct answers")
					}
				}.onSubmit(of: .text) {
						answerSubmitted()
				}.navigationTitle("Question \(questionsAnswered+1 > questionsNum ? questionsNum : questionsAnswered+1) of \(questionsNum)")
					.alert("Pencil's down! The quiz is over.", isPresented: $showingGameEndAlert) {
						Button("Set up new game", action: resetGame)
					} message: {
						Text("\(gameEndAlertMessage)")
					}
			}
			
		}
	}
	
	func startGame() {
		if (numberSelection == 0 || numberSelection == 1){
			setUpAlertTitle = "You can't use \(numberSelection) as a selection"
			setUpAlertMessage = "That's too easy!"
			showingSetUpAlert = true
			return
		}
		
		getNewRandomNumber()
		answerIsFocused = true
		settingUpGame = false
	}
	
	func answerSubmitted() {
		questionsAnswered += 1
		let correct = checkAnswer(chosenNumber: numberSelection, randomNumber: randomNumber, answer: answer)
		
		if(correct) {
			questionsCorrect += 1
		}
		print("Questions answered: \(questionsAnswered)")
		print("Number of questions: \(questionsNum)")
		print("Questions correct: \(questionsCorrect)")
		
		if (questionsNum == questionsAnswered){
			endGame()
		}
		else{
			refreshQuestion()
		}
	}
	
	func endGame() {
		if (questionsCorrect == questionsAnswered) {
			gameEndAlertMessage = "You answered all questions correctly!"
		}
		else {
			gameEndAlertMessage = "You got \(questionsCorrect) questions correct."
		}
		showingGameEndAlert = true
	}
	
	func resetGame() {
		questionsAnswered = 0
		questionsCorrect = 0
		answer = nil
		getNewRandomNumber()
		gameEndAlertMessage = ""
		answerIsFocused = false
		settingUpGame = true
	}
	
	func refreshQuestion() {
		getNewRandomNumber()
		answer = nil
		answerIsFocused = true
	}
	
	func getNewRandomNumber() {
		randomNumber = Int.random(in: 2...12)
	}
	
	func checkAnswer(chosenNumber: Int, randomNumber: Int, answer: Int? = 0) -> Bool {
		chosenNumber * randomNumber == answer
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
