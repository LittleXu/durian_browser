//
//  durianbrowserApp.swift
//  durianbrowser
//
//  Created by liuxu on 2025/2/9.
//

import SwiftUI

@main
struct durianbrowserApp: App {
    
    @StateObject var store = BookmarkStore()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store) // 注入全局环境对象
        }
    }
}
