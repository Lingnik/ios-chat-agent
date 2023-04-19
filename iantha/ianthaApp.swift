//
//  ianthaApp.swift
//  iantha
//
//  Created by Taylor Meek on 4/3/23.
//

import SwiftUI

@main
struct ianthaApp: App {
    @StateObject private var contentViewModel = ContentViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentViewModel)
        }
    }
}
