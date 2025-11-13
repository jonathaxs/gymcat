//
//  ContentView.swift
//  GymCat App
//
//  Created by @jonathaxs on 2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("waterIntake") private var waterIntake: Int = 0
    let waterGoal = 2000

    var body: some View {
        VStack(spacing: 30) {
            Text("💧 Consumo de Água")
                .font(.title)
                .fontWeight(.bold)

            Text("\(waterIntake) ml de \(waterGoal) ml")
                .font(.headline)

            ProgressView(value: Float(waterIntake), total: Float(waterGoal))
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, 40)

            Button(action: {
                if waterIntake + 250 <= waterGoal {
                    waterIntake += 250
                } else {
                    waterIntake = waterGoal
                }
            }) {
                Text("+250ml")
                    .font(.title2)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Button(action: {
                waterIntake = 0
            }) {
                Text("Resetar dia")
                    .font(.body)
                    .padding(8)
                    .frame(width: 200)
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
