//
//  BookmarkView.swift
//  durianbrowser
//
//  Created by liuxu on 2025/2/14.
//

import Foundation
import UIKit
import SwiftUI

struct BookmarkView: View {
    let bookmark: Bookmark
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(bookmark.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(bookmark.url)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer() // 推动箭头到最右边
            Image(systemName: "chevron.right")
                .foregroundColor(.gray) // 颜色与 URL 一
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
//        .padding(.horizontal, 8)
        
       
    }
}


#Preview {
    BookmarkView(bookmark: Bookmark(name: "百度一下, 你就知道", url: "https://www.baidu.com/"))
}
