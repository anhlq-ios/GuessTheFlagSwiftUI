//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anh Le on 14/02/2022.
//

import SwiftUI

struct FlagImage: View {
    let flagName: String
    
    var body: some View {
        Image(flagName, bundle: nil)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 4)
    }
}

struct ProminentModider: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func makeProminent() -> some View {
        modifier(ProminentModider())
    }
}

struct ContentView: View {
    @State private var scoreTitle = ""
    @State private var showingAlert = false
    @State private var reachMaxTurn = false
    @State private var score = 0
    @State private var message = ""
    @State private var turnCount = 1
    
    @State private var spinningDegrees: [Double] = [0, 0, 0]
    @State private var opacityArray: [Double] = [1, 1, 1]
    @State private var scaleArray: [Double] = [1, 1, 1]
    
    private let maximumTurn = 8
    
    @State private var countries = ["Estonia" , "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswers = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                                   .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                                  ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Select the right flag for")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswers])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            handleAnimation(number)
                            buttonTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                        }
                        .rotation3DEffect(.degrees(spinningDegrees[number]), axis: (x: 0, y: 1, z: 1))
                        .opacity(opacityArray[number])
                        .scaleEffect(scaleArray[number], anchor: .center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: .circular))
                
                Spacer()
                Spacer()
                
                Text("Your score is \(score)")
                    .makeProminent()
                Spacer()
            }
            .padding()
        }.alert(scoreTitle, isPresented: $showingAlert) {
            Button("Continue") {
                resetAnimation()
                shuffle()
            }
        } message: {
            Text(message)
        }
        .alert("Your total score is \(score)/\(maximumTurn)", isPresented: $reachMaxTurn) {
            Button("Reset") {
                reset()
                resetAnimation()
            }
        }
    }
    
    private func buttonTapped(_ number: Int) {
        if number == correctAnswers {
            scoreTitle = "Correct"
            score += 1
            message = "Your score is \(score)/\(turnCount)"
        } else {
            scoreTitle = "Wrong"
            message = "That's the flag of \(countries[correctAnswers])!\nYour score is \(score)/\(turnCount)"
        }
        if turnCount < maximumTurn {
            turnCount += 1
        } else {
            reachMaxTurn = true
        }
        showingAlert = true
    }
    
    private func handleAnimation(_ number: Int) {
        withAnimation {
            for value in 0 ..< 3 {
                if value != number {
                    opacityArray[value] = 0.25
                    scaleArray[value] = 0.75
                }
            }
            spinningDegrees[number] = 360
        }
    }
    
    private func resetAnimation() {
        withAnimation {
            opacityArray = [1, 1, 1]
            scaleArray = [1, 1, 1]
            spinningDegrees = [0, 0, 0]
        }
    }
    
    private func shuffle() {
        countries.shuffle()
        correctAnswers = Int.random(in: 0...2)
    }
    
    private func reset() {
        turnCount = 1
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
