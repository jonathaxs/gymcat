// ⌘
//  GymCat/GymCatApp/Views/Achievements/MonthlyCalendarView.swift
//
//  Purpose: Custom monthly calendar grid used by AchievementsView.
//
//  Created by @jonathaxs on 2026-01-27.
// ⌘

import SwiftUI

/// A lightweight monthly calendar view that displays one emoji per day when available.
/// This is used in AchievementsView to visually indicate which cat was earned on each day.
struct MonthlyCalendarView: View {

    /// Month currently being displayed (any date inside the month)
    let monthDate: Date

    /// Selected day (shared with parent view)
    @Binding var selectedDate: Date

    /// Mapping of day -> emoji (keyed by startOfDay)
    let emojiByDay: [Date: String]

    private let calendar = Calendar.current

    // Localized one-letter weekday symbols ordered by the user's calendar settings.
    private var weekdaySymbols: [String] {
        // shortStandaloneWeekdaySymbols is locale-aware (e.g. "dom.", "seg.")
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let startIndex = (calendar.firstWeekday - 1) % symbols.count
        let ordered = Array(symbols[startIndex...] + symbols[..<startIndex])

        return ordered.map { symbol in
            let cleaned = symbol
                .replacingOccurrences(of: ".", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            return String(cleaned.prefix(1)).uppercased()
        }
    }

    var body: some View {
        let days = daysInMonth(for: monthDate)

        VStack(spacing: 8) {
            // Weekday header (D S T Q Q S S)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Month grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(days, id: \.self) { date in
                    dayCell(for: date)
                }
            }
        }
    }

    // MARK: - Day cell

    @ViewBuilder
    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let dayNumber = calendar.component(.day, from: date)
        let emoji = emojiByDay[calendar.startOfDay(for: date)]

        VStack(spacing: 4) {
            Text("\(dayNumber)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? .white : .primary)

            if let emoji {
                Text(emoji)
                    .font(.body)
            }
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.accentColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(Rectangle())
        .onTapGesture {
            selectedDate = date
        }
    }

    // MARK: - Helpers

    /// Returns all dates to render for the month grid (including leading empty days).
    private func daysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else {
            return []
        }

        let start = firstWeek.start
        let end = monthInterval.end

        var days: [Date] = []
        var current = start

        while current < end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }

        return days
    }
}
