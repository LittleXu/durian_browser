//
//  BrowerView.swift
//  durianbrowser
//
//  Created by liuxu on 2025/2/13.
//

import Foundation
import SwiftUI
import WebKit

struct BrowerView: View {
    let urlString: String
    var body: some View {
        _BrowerView(urlString: urlString)
    }
}


#Preview {
    NavigationView {
        BrowerView(urlString: "https://www.baidu.com/")
    }
}



struct _BrowerView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: _BrowerView

        init(_ parent: _BrowerView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView load failed: \(error.localizedDescription)")
        }
    }
}


