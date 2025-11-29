//
//  GymCat/GymCatApp/Views/Today/FinishDayButton.swift
//
//  Created by @jonathaxs on 2025-11-26.
/*  Criado por @jonathaxs em 2025-11-26. */
// ⌘

import SwiftUI

struct FinishDayButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 35))
        }
        .buttonStyle(GlassButtonStyle(tint: .green))
        .accessibilityLabel(String(localized: "today.button.finish.icon.accessibility"))
    }
}

#Preview {
    FinishDayButton(action: {})
        .padding()
        .background(Color.blue)
}
