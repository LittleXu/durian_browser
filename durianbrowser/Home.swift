import SwiftUI
import SwiftSoup
import Kingfisher
struct HomeView: View {
    
    @State private var urlString: String = ""
    @State private var bookmarks: [Bookmark] = [
        Bookmark(name: "谷歌", url: "https://www.google.com/"),
        Bookmark(name: "百度", url: "https://www.baidu.com/"),
        Bookmark(name: "必应", url: "https://cn.bing.com"),
        Bookmark(name: "360搜索", url: "https://www.so.com/"),
        Bookmark(name: "苹果中国", url: "https://www.apple.com.cn/"),
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
            VStack(spacing: 0) {
                ScrollView {
                    TextField("请输入网址", text: $urlString)
                        .padding(.horizontal, 16)  // 设置左右内边距，确保文本和边框之间有间隔
                        .frame(height: 55)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.black))) // 绘制边框
                        .cornerRadius(16)
                        .padding(.bottom, 16)
                    HStack {
                        Text("书签")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {
                               // 点击事件处理
                               print("查看更多")
                           }) {
                               HStack(spacing: 0) {
                                   Text("查看更多")
                                       .foregroundColor(.gray) // 设置按钮文本颜色
                                   Image(systemName: "chevron.right")
                                       .foregroundColor(.gray)
                               }
                           }
                    }
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading) // 让 LazyHStack 撑满宽度

                    LazyVStack {
                        ForEach(bookmarks) { bookmark in
                            BookmarkView(bookmark: bookmark)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationTitle("DURIAN")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: addBookmark) {
//                        Image(systemName: "plus")
//                            .foregroundColor(.black)
//                    }
//                }
//            }
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
