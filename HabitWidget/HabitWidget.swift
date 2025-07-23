import WidgetKit
import SwiftUI

// MARK: Timeline Entry
struct HabitEntry: TimelineEntry {
    let date: Date
    let habits: [Habit]
}


// MARK: Provider
struct HabitProvider: TimelineProvider {

    let store = HabitStore()

    func placeholder(in context: Context) -> HabitEntry {
        HabitEntry(date: .now, habits: store.habits)
    }

    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) {
        completion(HabitEntry(date: .now, habits: store.habits))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HabitEntry>) -> Void) {
        let habits = HabitStore().habits          // new snapshot from App-Group
        let entry  = HabitEntry(date: Date(), habits: habits)

        let next = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0),
            matchingPolicy: .nextTime)!

        completion(Timeline(entries: [entry], policy: .after(next)))
    }

}

struct HabitWidgetEntryView: View {
    var entry: HabitEntry

    var body: some View {
        content
            .containerBackground(.background, for: .widget)
    }


    @ViewBuilder
    private var content: some View {
        if entry.habits.isEmpty {
            Text("No habits")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            HStack(spacing: 6) {
                ForEach(entry.habits.prefix(5)) { habit in
                    let today = Calendar.current.startOfDay(for: Date())
                    let done = habit.records.contains { $0.date == today && $0.isDone }

                    RoundedRectangle(cornerRadius: 4)
                        .fill(done ? .green : .gray.opacity(0.25))
                        .frame(width: 20, height: 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

}


// MARK: – Widget declaration
struct HabitWidget: Widget {
    let kind = "HabitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: HabitProvider()
        ) { entry in
            HabitWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit progress")
        .description("Shows whether today's habits are complete")
        .supportedFamilies([.systemSmall])
    }
}


