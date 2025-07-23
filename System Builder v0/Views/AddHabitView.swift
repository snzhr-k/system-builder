import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    let onSave: (String) -> Void

    var body: some View {
        NavigationStack {
            Form { TextField("Name of the habit", text: $name) }
                .navigationTitle("New habit")
                .toolbar {
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            onSave(name.trimmingCharacters(in: .whitespaces))
                            dismiss()
                        }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) { dismiss() }
                    }
                }
        }
    }
}
