//
//  BookmarkManagerView.swift
//  durianbrowser
//
//  Created by liuxu on 2025/5/15.
//

import Foundation
import SwiftUI

struct BookmarkManagerView: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject var store: BookmarkStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isPresentingEditor = false
    @State private var editingBookmark: Bookmark? = nil
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.bookmarks) { bookmark in
                    Button {
                        editingBookmark = bookmark
                        isPresentingEditor = true
                    } label: {
                        BookmarkManagerItemView(bookmark: bookmark)
                    }
                    .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
            .environment(\.editMode, editMode) // 传递 editMode 环境
            .listStyle(PlainListStyle())
            .navigationTitle("书签管理")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.blue)
                            // 不加文字就不会显示
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: toggleEdit) {
                            Image(systemName: editMode?.wrappedValue == .active ? "checkmark" : "square.and.pencil"
                            )
                        }
                        Button(action: {
                            editingBookmark = nil
                            isPresentingEditor = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    
                }
            }
            .sheet(item: $editingBookmark) { bookmark in
                BookmarkEditView(bookmark: bookmark) { result in
                    if let index = store.bookmarks.firstIndex(where: { $0.id == result.id }) {
                        store.bookmarks[index] = result
                        store.save()
                    } else {
                        store.add(result)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func delete(at offsets: IndexSet) {
        store.remove(at: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        store.move(from: source, to: destination)
    }
    
    private func toggleEdit() {
        withAnimation {
            if editMode?.wrappedValue == .active {
                editMode?.wrappedValue = .inactive
            } else {
                editMode?.wrappedValue = .active
            }
        }
    }
}


#Preview {
    NavigationView {
        BookmarkManagerView().environmentObject(BookmarkStore()) // 注入全局环境对象
    }
}
