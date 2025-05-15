//
//  BookmarkStore.swift
//  durianbrowser
//
//  Created by liuxu on 2025/5/15.
//

import Foundation

private let BookmarkUserDefaultsKey = "BookmarkUserDefaultsKey"


class BookmarkStore: ObservableObject {
    @Published var bookmarks: [Bookmark] = []
    
    init() {
        load()
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: BookmarkUserDefaultsKey),
           let decoded = try? JSONDecoder().decode([Bookmark].self, from: data) {
            self.bookmarks = decoded
        } else {
            self.bookmarks = [
                Bookmark(name: "谷歌", url: "https://www.google.com/"),
                Bookmark(name: "百度", url: "https://www.baidu.com/"),
                Bookmark(name: "必应", url: "https://cn.bing.com"),
                Bookmark(name: "360搜索", url: "https://www.so.com/"),
                Bookmark(name: "苹果中国", url: "https://www.apple.com.cn/"),
                Bookmark(name: "新浪微博", url: "https://www.weibo.com/"),
            ]
        }
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(encoded, forKey: BookmarkUserDefaultsKey)
        }
    }

    func add(_ bookmark: Bookmark) {
        bookmarks.append(bookmark)
        save()
    }

    func remove(at offsets: IndexSet) {
        bookmarks.remove(atOffsets: offsets)
        save()
    }

    func move(from source: IndexSet, to destination: Int) {
        bookmarks.move(fromOffsets: source, toOffset: destination)
        save()
    }
}
