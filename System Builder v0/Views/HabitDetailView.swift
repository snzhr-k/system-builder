import SwiftUI
import WidgetKit

struct HabitDetailView: View {
    // shared store from App entry-point
    @EnvironmentObject private var store: HabitStore

    let habit: Habit

    // 7 columns: Mon to Sunday
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 7)//this is where this "design" flaw comes from
    private let cal     = Calendar.current

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 5) {
                ForEach(daysSequence(), id: \.self) { day in
                    Rectangle()
                        .fill(squareColor(for: day))
                        .frame(width: 20, height: 20)
                        .cornerRadius(2)
                        .overlay(todayOverlay(for: day))
                }
            }
            .padding()
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleToday) {
                    Image(systemName: doneToday ? "checkmark.circle.fill"
                                                : "checkmark.circle")
                        .imageScale(.large)
                }
                .disabled(doneToday)
            }
        }
    }

    // MARK: - Computed helpers
    private var doneToday: Bool {
        let today = cal.startOfDay(for: .now)
        return store.habits
            .first { $0.id == habit.id }?
            .records.contains { $0.date == today && $0.isDone } ?? false
    }

    private func squareColor(for day: Date) -> Color {
        guard let habitIndex = store.habits.firstIndex(where: { $0.id == habit.id }) else {
            return .gray.opacity(0.25)
        }

        let done = store.habits[habitIndex]
            .records
            .contains { $0.date == day && $0.isDone }

        if !done { return .gray.opacity(0.25) }

        // intensity by streak length
        let streak = streakLength(endingAt: day, in: store.habits[habitIndex])
        switch streak {
        case 1:       return Color.green.opacity(0.35)
        case 2...3:   return Color.green.opacity(0.55)
        case 4...6:   return Color.green.opacity(0.75)
        default:      return Color.green
        }
    }

    private func todayOverlay(for day: Date) -> some View {
        cal.isDateInToday(day)
        ? AnyView(RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.yellow, lineWidth: 2))
        : AnyView(EmptyView())
    }

    private func daysSequence() -> [Date] {
        let start      = habit.records.first?.date
                     ?? cal.startOfDay(for: .now)           // fallback: today
        let span       = 365                                // show 1 full year
        return (0...span)
            .compactMap { cal.date(byAdding: .day, value: $0, to: start) }
    }

    private func streakLength(endingAt date: Date, in habit: Habit) -> Int {
        var cursor = date
        var streak = 0
        while habit.records.contains(where: { $0.date == cursor && $0.isDone }) {
            streak += 1
            guard let prev = cal.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return streak
    }

    // MARK: - Actions
    private func toggleToday() {
        store.toggleToday(for: habit)
        WidgetCenter.shared.reloadAllTimelines()
    }
}


