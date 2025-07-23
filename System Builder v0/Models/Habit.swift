import Foundation
import SwiftUI

struct DayRecord: Codable, Hashable{
    let date: Date //why date is let
    var isDone: Bool //and why isDone is var?
}

struct Habit: Identifiable, Codable, Hashable{
    let id: UUID
    var name: String
    var records: [DayRecord]
    
    //constructor method
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.records = []
    }
}

