// ⌘
//  GymCat/GymCatApp/Views/Achievements/AchievementsView.swift
//
//  Purpose: History screen that lists saved DailyRecords and allows editing recent entries.
//
//  Created by @jonathaxs on 2025-11-14.
// ⌘

import SwiftUI
import SwiftData

// MARK: - Achievements Screen
// Displays all saved DailyRecord entries using SwiftData, sorted newest to oldest.
struct AchievementsView: View {
    
    // SwiftData query that retrieves all daily records.
    // Sorting by date in reverse order shows the most recent day first.
    @Query(sort: \DailyRecord.date, order: .reverse) private var records: [DailyRecord]
    @Environment(\.modelContext) private var modelContext
    
    // Controls which record is currently being edited in a sheet.
    @State private var editingRecord: DailyRecord?
    
    private enum FilterMode: String {
        case all
        case day
    }

    // Persists the user's last selection for the Achievements filters.
    @AppStorage("achievements.filterMode") private var storedFilterMode: String = FilterMode.all.rawValue
    @AppStorage("achievements.selectedDate") private var storedSelectedDateTimestamp: Double = Date().timeIntervalSince1970

    // Controls list filtering on the Achievements screen.
    @State private var filterMode: FilterMode = .all
    @State private var selectedDate: Date = Date()
    
    // Defines how long a record remains editable after being created.
    private static let editWindowHours: Int = 72
    private static let editWindow: TimeInterval = TimeInterval(Self.editWindowHours * 60 * 60)
    
    // MARK: - Actions
    // Deletes the selected record from the database.
    private func deleteRecord(offsets: IndexSet, in list: [DailyRecord]) {
        for index in offsets {
            let record = list[index]
            modelContext.delete(record)
        }
    }
    
    // A record can be edited only within the configured edit window (default: 72 hours).
    private func canEdit(_ record: DailyRecord) -> Bool {
        let now = Date()
        let interval = now.timeIntervalSince(record.date)
        return interval >= 0 && interval <= Self.editWindow
    }
    
    private func dailyCat(for record: DailyRecord) -> DailyCat {
        let progress = Double(record.percent) / 100.0
        return DailyCat.from(progress: progress)
    }
    
    private var visibleRecords: [DailyRecord] {
        switch filterMode {
        case .all:
            return records
        case .day:
            let calendar = Calendar.current
            return records.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
        }
    }
    
    var body: some View {
        
        // MARK: - View Body
        // Visual structure for the achievements screen using NavigationStack.
        // Each record is displayed in a list row with emoji, title, date, and points.
        NavigationStack {
            Group {
                if records.isEmpty {
                    
                    // Empty state view.
                    // Shown when there are no records to display.
                    ContentUnavailableView(
                        String(localized: "achievements.empty.title"),
                        systemImage: "trophy.fill",
                        description: Text(String(localized: "achievements.empty.description"))
                    )
                } else {
                    List {
                        Section {
                            Picker(String(localized: "achievements.filter.title"), selection: $filterMode) {
                                Text(String(localized: "achievements.filter.all")).tag(FilterMode.all)
                                Text(String(localized: "achievements.filter.day")).tag(FilterMode.day)
                            }
                            .pickerStyle(.segmented)

                            if filterMode == .day {
                                DatePicker(
                                    String(localized: "achievements.calendar.title"),
                                    selection: $selectedDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.graphical)
                            }
                        }

                        ForEach(visibleRecords) { record in

                            // Individual history row.
                            // Shows the cat emoji, title, date, and points for that day.
                            HStack(spacing: 16) {
                                Text(dailyCat(for: record).emoji)
                                    .font(.largeTitle)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dailyCat(for: record).name)
                                        .font(.headline)

                                    Text(record.date, style: .date)
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }

                                Spacer()

                                Text("\(record.points) \(String(localized: "achievements.points.total"))")
                                    .font(.subheadline.bold())

                                // Edit button – only visible for records within the last 72 hours.
                                if canEdit(record) {
                                    Button {
                                        editingRecord = record
                                    } label: {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundStyle(.blue)
                                            .padding(10)
                                            .background(.ultraThinMaterial, in: Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(.blue.opacity(0.25), lineWidth: 1)
                                            )
                                            .shadow(radius: 6, y: 3)
                                    }
                                    .buttonStyle(PressScaleButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete { offsets in
                            deleteRecord(offsets: offsets, in: visibleRecords)
                        }
                    }
                }
            }
            
            // Navigation title for the achievements screen.
            .navigationTitle(String(localized: "achievements.header.title"))
            .onAppear {
                // Restore last used filter state.
                filterMode = FilterMode(rawValue: storedFilterMode) ?? .all
                selectedDate = Date(timeIntervalSince1970: storedSelectedDateTimestamp)
            }
            .onChange(of: filterMode) { _, newValue in
                storedFilterMode = newValue.rawValue
            }
            .onChange(of: selectedDate) { _, newValue in
                storedSelectedDateTimestamp = newValue.timeIntervalSince1970
            }
        }
        .sheet(item: $editingRecord) { record in
            EditTodayView(record: record)
        }
    }
}

private struct PressScaleButtonStyle: ButtonStyle {
    private static let pressedScale: CGFloat = 0.92
    private static let springResponse: Double = 0.22
    private static let springDamping: Double = 0.65

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? Self.pressedScale : 1.0)
            .animation(
                .spring(response: Self.springResponse, dampingFraction: Self.springDamping),
                value: configuration.isPressed
            )
    }
}

#Preview {
    AchievementsView()
        .modelContainer(for: DailyRecord.self, inMemory: true)
}
