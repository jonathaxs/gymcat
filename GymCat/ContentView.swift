//
//  ContentView.swift
//  GymCat
//
//  Created by Jonathas Motta on 16/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var consumoAgua: Int = 0
    let metaAgua = 2000

    var body: some View {
        VStack(spacing: 30) {
            Text("💧 Consumo de Água")
                .font(.title)
                .fontWeight(.bold)

            Text("\(consumoAgua) ml de \(metaAgua) ml")
                .font(.headline)

            ProgressView(value: Float(consumoAgua), total: Float(metaAgua))
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, 40)

            Button(action: {
                if consumoAgua + 250 <= metaAgua {
                    consumoAgua += 250
                } else {
                    consumoAgua = metaAgua
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

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
