import SwiftUI

struct HabitsListView: View {
    @EnvironmentObject private var store: HabitStore
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.habits) { habit in
                    let doneToday = store.isDoneToday(habit)

                    NavigationLink(value: habit) { Text(habit.name) }

                        // show leading swipe ONLY when not done yet
                        .if(!doneToday) { view in
                            view.swipeActions(edge: .leading) {
                                Button {
                                    store.toggleToday(for: habit)
                                } label: {
                                    Label("✓ Today", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) { store.delete(habit) } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete { indexSet in
                    indexSet.map { store.habits[$0] }.forEach(store.delete)
                }
            }
            .navigationTitle("Habits")
            .navigationDestination(for: Habit.self) { habit in
                HabitDetailView(habit: habit)
            }
            .toolbar {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddHabitView { name in
                    store.addHabit(name: name)
                }
            }
        }
    }
}

#Preview{
    HabitsListView()
}
