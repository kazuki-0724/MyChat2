//
//  NewsView.swift
//  MyChat2
//
//

import SwiftUI

struct NewsView: View {
    
    @StateObject private var parser = RSSParser()
    
    var body: some View {
        NavigationStack {
            List(parser.items) { item in
                // NavigationLinkで押下時に仕込んであるURLでWebViewに飛ばす
                NavigationLink(destination: WebView(url: URL(string: item.link)!)) {
                    // closureで表示内容をTextで埋め込む
                    Text(item.title)
                }
            }
            .navigationTitle("ニュース")
            .onAppear {
                parser.parseFeed(url: "https://news.google.com/rss?hl=ja&gl=JP&ceid=JP:ja")
            }
        }
    }
}

#Preview {
    ContentView()
}
