//
//  Bookmark.swift
//  durianbrowser
//
//  Created by liuxu on 2025/5/15.
//

import Foundation

struct Bookmark: Identifiable, Codable {
    let id = UUID()
    var name: String
    var url: String
    var favicon: String?
}
