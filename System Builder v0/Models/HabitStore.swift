import Foundation
import Combine
#if canImport(WidgetKit)
import WidgetKit
#endif

final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] = []
    private let key = "habit.habits"
    init() { load() }
    
    private let sharedDefaults: UserDefaults = {
        UserDefaults(suiteName: "group.com.snzhrk.habits")!
    }()
    
    //MARK: 1
    func addHabit(name: String){
        habits.append(Habit(name:name))
        save()
    }
    
    func delete(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        save()
    }

    func rename(_ habit: Habit, to newName: String) {
        guard let i = index(of: habit) else { return }
        habits[i].name = newName
        save()
    }
    
    func toggleToday(for habit: Habit) {
        guard let i = index(of: habit) else { return }
        let today = Calendar.current.startOfDay(for: .now)

        if let r = habits[i].records.firstIndex(where: { $0.date == today }) {
            habits[i].records[r].isDone.toggle()
        } else {
            habits[i].records.append(.init(date: today, isDone: true))
        }
        save()
    }
    
    func isDoneToday(_ habit: Habit) -> Bool {
        let today = Calendar.current.startOfDay(for: .now)
        return habits
            .first(where: { $0.id == habit.id })?
            .records.contains(where: { $0.date == today && $0.isDone }) ?? false
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        sharedDefaults.set(data, forKey: key)
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadTimelines(ofKind: "HabitWidget")   // ← exact widget kind
        #endif
    }

    private func load() {
        guard
            let data = sharedDefaults.data(forKey: key),
            let decoded = try? JSONDecoder().decode([Habit].self, from: data)
        else { return }
        habits = decoded
        
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadTimelines(ofKind: "HabitWidget")   // ← exact widget kind
        #endif
    }

    private func index(of habit: Habit) -> Int? {
        habits.firstIndex { $0.id == habit.id }
    }
    
}
