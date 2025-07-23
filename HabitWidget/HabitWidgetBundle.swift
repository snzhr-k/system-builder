//
//  HabitWidgetBundle.swift
//  HabitWidget
//
//  Created by snzhrk on 15.07.2025.
//

import WidgetKit
import SwiftUI

@main
struct HabitWidgetBundle: WidgetBundle {
    var body: some Widget {
        HabitWidget()
        HabitWidgetControl()
        HabitWidgetLiveActivity()
    }
}
