//
//  BookmarkEditView.swift
//  durianbrowser
//
//  Created by liuxu on 2025/5/15.
//

import Foundation
import SwiftUI

struct BookmarkEditView: View {
    @Environment(\.dismiss) var dismiss

    @State private var name: String
    @State private var url: String
    let id: UUID

    let onSave: (Bookmark) -> Void

    init(bookmark: Bookmark?, onSave: @escaping (Bookmark) -> Void) {
        self._name = State(initialValue: bookmark?.name ?? "")
        self._url = State(initialValue: bookmark?.url ?? "")
        self.id = bookmark?.id ?? UUID()
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("书签信息")) {
                    TextField("名称", text: $name)
                    TextField("网址", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("编辑书签")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let newBookmark = Bookmark(name: name, url: url, favicon: nil)
                        onSave(newBookmark)
                        dismiss()
                    }
                    .disabled(name.isEmpty || url.isEmpty)
                }
            }
        }
    }
}
