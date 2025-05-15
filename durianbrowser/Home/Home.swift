import SwiftUI
import SwiftSoup
import Kingfisher
struct HomeView: View {
    @EnvironmentObject var store: BookmarkStore
    @State private var urlString: String = ""
    @State private var isPresentingInputView = false
    
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
                    //                    TextField("请输入网址", text: $urlString)
                    //                        .padding(.horizontal, 16)  // 设置左右内边距，确保文本和边框之间有间隔
                    //                        .frame(height: 55)
                    //                        .textFieldStyle(PlainTextFieldStyle())
                    //                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.black))) // 绘制边框
                    //                        .cornerRadius(16)
                    //                        .padding(.bottom, 16)
                    
                    
                    // 伪输入框，点击触发 Sheet
                    Button(action: {
                        isPresentingInputView = true
                    }) {
                        HStack {
                            Text(urlString.isEmpty ? "请输入网址" : urlString)
                                .foregroundColor(urlString.isEmpty ? .gray : .black)
                                .padding(.horizontal, 16)
                            Spacer()
                        }
                        .frame(height: 55)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.black)))
                        .cornerRadius(16)
                    }
                    .padding(.bottom, 16)
                    .fullScreenCover(isPresented: $isPresentingInputView) {
                        URLInputSheetView(urlString: $urlString, isPresented: $isPresentingInputView)
                    }
                    
                    
                    HStack {
                        Text("书签")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        NavigationLink {
                            BookmarkManagerView()
                        } label: {
                            HStack(spacing: 0) {
                                Text("编辑")
                                    .foregroundColor(.gray) // 设置按钮文本颜色
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .leading) // 让 LazyHStack 撑满宽度
                    
                    LazyVStack {
                        ForEach(store.bookmarks) { bookmark in
                            NavigationLink {
                                BrowerView(urlString: bookmark.url)
                            } label: {
                                BookmarkView(bookmark: bookmark)
                            }
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .background(Color(.white).ignoresSafeArea())
            .navigationTitle("DURIAN")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(BookmarkStore()) // 注入全局环境对象
    }
}
