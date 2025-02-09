//import SwiftUI
//
//struct HomeView: View {
//    @State private var urlString: String = ""
//    @State private var bookmarks: [Bookmark] = [
//        Bookmark(name: "谷歌", url: "https://www.google.com/"),
//        Bookmark(name: "百度", url: "https://www.baidu.com/"),
//        Bookmark(name: "抖音", url: "https://www.douyin.com/"),
//        Bookmark(name: "小红书", url: "https://www.xiaohongshu.com/"),
//        Bookmark(name: "必应", url: "https://www.bing.com/"),
//        Bookmark(name: "百度", url: "https://www.baidu.com/"),
//        Bookmark(name: "百度", url: "https://www.baidu.com/"),
//        Bookmark(name: "百度", url: "https://www.baidu.com/"),
//    ]
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                TextField("Enter URL", text: $urlString)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
//                        ForEach($bookmarks) { $bookmark in
//                            Button(action: {
//                                urlString = bookmark.url
//                            }) {
//                                VStack {
//                                    AsyncImage(url: URL(string: bookmark.favicon ?? "")) { image in
//                                        image.resizable()
//                                    } placeholder: {
//                                        Image(systemName: "globe")
//                                            .resizable()
//                                            .foregroundColor(.white)
//                                    }
//                                    .frame(width: 50, height: 50)
//                                    .padding()
//                                    .clipShape(Circle())
//
//                                    Text(bookmark.name)
//                                        .font(.caption)
//                                        .foregroundColor(.primary)
//                                        .lineLimit(1)
//                                }
//                                .padding()
//                                .background(Color(.systemGray5))
//                                .cornerRadius(12)
//                            }
//                            .onAppear {
//                                Task {
//                                    await fetchFavicon(for: index)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//
//                Spacer()
//            }
//            .background(Color(.systemGray6).ignoresSafeArea())
//            .navigationTitle(Text("DURIAN"))
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: addBookmark) {
//                        Image(systemName: "plus")
//                            .foregroundColor(.blue)
//                    }
//                }
//            }
//        }
//    }
//
//    func addBookmark() {
//        let newBookmark = Bookmark(name: "New Site", url: "https://example.com")
//        bookmarks.append(newBookmark)
//    }
//
//    /// **获取 Favicon 并更新 bookmarks**
//    func fetchFavicon(for index: Int) async {
//        guard let url = URL(string: bookmarks[index].url) else { return }
//
//        let defaultFavicon = url.scheme! + "://" + url.host! + "/favicon.ico"
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            if let html = String(data: data, encoding: .utf8),
//               let faviconURL = extractFaviconURL(from: html, baseURL: url) {
//                DispatchQueue.main.async {
//                    bookmarks[index].favicon = faviconURL
//                }
//            } else {
//                DispatchQueue.main.async {
//                    bookmarks[index].favicon = defaultFavicon
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                bookmarks[index].favicon = defaultFavicon
//            }
//        }
//    }
//}
//
///// **解析 HTML 获取 Favicon**
//func extractFaviconURL(from html: String, baseURL: URL) -> String? {
//    let regexPattern = "<link[^>]+rel=[\"']?icon[\"']?[^>]+href=[\"']([^\"']+)[\"']"
//
//    if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive),
//       let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count)) {
//
//        if let range = Range(match.range(at: 1), in: html) {
//            var faviconPath = String(html[range])
//
//            if faviconPath.hasPrefix("//") {
//                faviconPath = "https:" + faviconPath
//            } else if faviconPath.hasPrefix("/") {
//                faviconPath = baseURL.scheme! + "://" + baseURL.host! + faviconPath
//            } else if !faviconPath.hasPrefix("http") {
//                faviconPath = baseURL.scheme! + "://" + baseURL.host! + "/" + faviconPath
//            }
//
//            return faviconPath
//        }
//    }
//
//    return nil
//}
//
//struct Bookmark: Identifiable {
//    let id = UUID()
//    var name: String
//    var url: String
//    var favicon: String?
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
//
import SwiftUI

struct HomeView: View {
    
    
    
    @State private var urlString: String = ""
    @State private var bookmarks: [Bookmark] = [
        Bookmark(name: "谷歌", url: "https://www.google.com/"),
        Bookmark(name: "百度", url: "https://www.baidu.com/"),
        Bookmark(name: "必应", url: "https://www.bing.com/"),
        Bookmark(name: "360搜索", url: "https://www.so.com/"),
        Bookmark(name: "雅虎", url: "https://sg.yahoo.com/"),
        Bookmark(name: "新浪微博", url: "https://www.weibo.com/"),
    ]

    // 修改navigation title的字体
    init() {
           var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle) /// the default large title font
           titleFont = UIFont(
               descriptor:
                   titleFont.fontDescriptor
                   .withDesign(.rounded)? /// make rounded
                   .withSymbolicTraits(.traitBold) /// make bold
                   ??
                   titleFont.fontDescriptor, /// return the normal title if customization failed
               size: titleFont.pointSize
           )
           
           /// set the rounded font
           UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
       }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("请输入网址", text: $urlString)
                    .padding(.horizontal, 16)  // 设置左右内边距，确保文本和边框之间有间隔
                    .frame(height: 55)
                    .textFieldStyle(PlainTextFieldStyle())
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.black))) // 绘制边框
                    .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                        ForEach(bookmarks.indices, id: \.self) { index in
                            let bookmark = bookmarks[index]  // ✅ 先存入局部变量，减少 SwiftUI 绑定计算
                            
                            Button(action: {
                                urlString = bookmark.url
                            }) {
                                VStack {
                                    AsyncImage(url: URL(string: bookmark.favicon ?? "")) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Image(systemName: "globe")
                                            .resizable()
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 50, height: 50)
                                    .padding()
                                    .clipShape(Circle())
                                    
                                    Text(bookmark.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                            }
                            .onAppear {
                                Task {
                                    await fetchFavicon(for: index)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationTitle("DURIAN")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addBookmark) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    func addBookmark() {
        let newBookmark = Bookmark(name: "New Site", url: "https://example.com")
        bookmarks.append(newBookmark)
    }
    
    /// **获取 Favicon 并更新 bookmarks**
    func fetchFavicon(for index: Int) async {
        guard let url = URL(string: bookmarks[index].url) else { return }
        
        let defaultFavicon = url.scheme! + "://" + url.host! + "/favicon.ico"
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let html = String(data: data, encoding: .utf8),
               let faviconURL = extractFaviconURL(from: html, baseURL: url) {
                DispatchQueue.main.async {
                    bookmarks[index].favicon = faviconURL
                }
            } else {
                DispatchQueue.main.async {
                    bookmarks[index].favicon = defaultFavicon
                }
            }
        } catch {
            DispatchQueue.main.async {
                bookmarks[index].favicon = defaultFavicon
            }
        }
    }
}

/// **解析 HTML 获取 Favicon**
func extractFaviconURL(from html: String, baseURL: URL) -> String? {
    let regexPattern = "<link[^>]+rel=[\"']?icon[\"']?[^>]+href=[\"']([^\"']+)[\"']"
    
    if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive),
       let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count)) {
        
        if let range = Range(match.range(at: 1), in: html) {
            var faviconPath = String(html[range])
            
            if faviconPath.hasPrefix("//") {
                faviconPath = "https:" + faviconPath
            } else if faviconPath.hasPrefix("/") {
                faviconPath = baseURL.scheme! + "://" + baseURL.host! + faviconPath
            } else if !faviconPath.hasPrefix("http") {
                faviconPath = baseURL.scheme! + "://" + baseURL.host! + "/" + faviconPath
            }
            
            return faviconPath
        }
    }
    
    return nil
}

struct Bookmark: Identifiable {
    let id = UUID()
    var name: String
    var url: String
    var favicon: String?
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
