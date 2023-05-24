//
//  SportRecordApp.swift
//  SportRecord
//
//  Created by 张凌浩 on 2023/5/22.
//

import SwiftUI

@main
struct SportRecordApp: App {
    @StateObject var userSettings = UserSettings()
    @StateObject var modal = Modal()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userSettings)
                .environmentObject(modal)
        }
    }
}
